class PaymentsPolicy
  attr_reader :service

  def initialize(service)
    @service = service
  end

  def current_payment
    current_payment = service.payments.where("paid = ?", false).first

    if current_payment.nil?
      return Payment.new(service_id: service.id)
    else
      return current_payment
    end
  end

  def equipments_not_paid
    service
      .equipment_customers
      .where("payment_id is NULL")
      .collect {|e_c| [ e_c.equipment.name, e_c.id ] }
  end

  # Create the payment for the service
  def save(params, user)
    price = params[:price]
    payment = current_payment

    payment.user = user
    payment.paid = true
    payment.paid_with = BigDecimal.new(params[:service][:paid_with])
    payment.change = BigDecimal.new(params[:service][:change])
    payment.service = service
    payment.payment_type_id = params[:payment][:payment_type_id]
    payment.discount = BigDecimal.new(params[:payment][:discount])
    payment.departure_date = params[:payment][:departure_date]
    payment.equipment_customer_ids = params[:equipment_customers]

    if params[:from_generic_price].eql?('true')
      generic_price = GenericPrice.find(price)
      payment.generic_price = generic_price
      payment.worforce = BigDecimal.new('0.00')
    else
      payment.worforce = BigDecimal.new(price)
      payment.generic_price = nil
    end

    payment.ticket = set_payment_number
    payment.cash_opening_services_sale = CashPolicy.new.cash_services_sales

    return payment
  end

  def save_image(image)
    unless image.blank?
      service.image_client = image
      return service.save
    end

    return false
  end

  private

  def set_payment_number
    return Payment.where('paid = ?', true).count + 1
  end


end
