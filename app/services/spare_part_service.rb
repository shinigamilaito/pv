class SparePartService
  attr_accessor :service, :spare_part

  def initialize(service = nil, spare_part = nil)
    @service = service
    @spare_part = spare_part
  end

  def add
    PgLock.new(name: "spare_part_service_add").lock do
      if is_available?(1)
        ActiveRecord::Base.transaction do
          raise 'Imposible decrementar el stock' unless decrement_total
          raise 'Error al registrar la refacción' unless create_service_spare_part
        end
      else
        raise 'Sin refacción. Las refacciones no son suficientes.'
      end
    end
  end

  def update_quantity(quantity, service_spare_part)
    PgLock.new(name: "spare_part_service_update_quantity").lock do
      @spare_part = service_spare_part.spare_part

      if quantity != service_spare_part.quantity
        increment_quantity = quantity - service_spare_part.quantity
        if is_available?(increment_quantity)
          ActiveRecord::Base.transaction do
            raise 'Error al actualizar la cantidad.' unless adjust_quantity_service_spare_part(quantity, service_spare_part)
            raise 'Error al actualizar la cantidad.' unless adjust_quantity_spare_part(increment_quantity, spare_part)
            return true
          end
        else
          raise 'Cantidad faltante.'
        end
      else
        return false
      end
    end
  end

  def delete(service_spare_part)
    PgLock.new(name: "spare_part_service_update_quantity").lock do
      ActiveRecord::Base.transaction do
        @service = service_spare_part.service
        @spare_part = service_spare_part.spare_part
        change = service_spare_part.quantity * -1
        raise 'Error al  ajustar el stock.' unless adjust_quantity_spare_part(change, spare_part)
        raise 'Error al eliminar la refacción' unless service_spare_part.destroy
      end
    end
  end

  private

  def is_available?(quantity)
    spare_part.total >= quantity
  end

  def decrement_total
    spare_part.total -= 1
    spare_part.save
  end

  def create_service_spare_part
    service_spare_part = ServiceSparePart.new
    service_spare_part.control_number = spare_part.code
    service_spare_part.name = spare_part.name
    service_spare_part.description = spare_part.description
    service_spare_part.price = spare_part.price
    service_spare_part.quantity = 1
    service_spare_part.spare_part = spare_part
    payments_policy = PaymentsPolicy.new(service)
    payment = payments_policy.current_payment
    payment.save
    service_spare_part.payment = payment
    service_spare_part.service = service
    service_spare_part.save
    service_spare_part
  end

  def adjust_quantity_service_spare_part(new_quantity, service_spare_part)
    service_spare_part.quantity = new_quantity
    service_spare_part.save
  end

  def adjust_quantity_spare_part(change, spare_part)
    spare_part.total -= change
    spare_part.save
  end

end
