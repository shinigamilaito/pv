class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :fixed_format_price, only: [:create, :update]

  def index
    @payments = Payment.all
  end

  def show
  end

  def new
    @payment = Payment.new
  end

  def edit
  end

  # Create the payment for the service
  def create
    unless cash_service_open?
      flash[:warning] = "La caja no ha sido abierta."
      redirect_to root_path and return
    end

    begin
      ActiveRecord::Base.transaction do
        PgLock.new(name: "payments_controller_create").lock do
          service = Service.find(params[:payment][:service_id])
          payments_policy = PaymentsPolicy.new(service)
          @payment = payments_policy.save(params, current_user)
          clear_variables

          if @payment.save
            @components = Component.all.order(:created_at)
            @equipments_not_paid = payments_policy.equipments_not_paid
          else
            raise 'Error al escribir los datos del pago. Intente nuevamente.'
          end
        end
      end
    rescue StandarError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  # Update the record of the payment, in services
  def update
    unless cash_service_open?
      flash[:warning] = "La caja no ha sido abierta."
      redirect_to root_path and return
    end

    begin
      ActiveRecord::Base.transaction do
        PgLock.new(name: "payments_controller_update").lock do
          service = Service.find(params[:payment][:service_id])
          payments_policy = PaymentsPolicy.new(service)
          @payment = payments_policy.save(params, current_user)
          clear_variables

          if @payment.save
            @components = Component.all.order(:created_at)
            @equipments_not_paid = payments_policy.equipments_not_paid
            render :create
          else
            raise 'Error al escribir los datos del pago. Intente nuevamente.'
          end
        end
      end
    rescue StandarError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:payment_type_id, :worforce, :discount, :departure_date, :generic_price_id, :service_id)
    end

    def clear_variables
      session[:worforce] = nil
      session[:discount] = nil
    end

    def fixed_format_price
        params[:service][:paid_with] = params[:service][:paid_with].gsub('$ ', '').gsub(',','')
        params[:service][:change] = params[:service][:change].gsub('$ ', '').gsub(',','')
    end
end
