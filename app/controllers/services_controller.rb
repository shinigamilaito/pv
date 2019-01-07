class ServicesController < ApplicationController

  def new
    @service = Service.new
    @folios = []
  end

  def create
    folio = params[:service][:folio]
    @folios = Service.find_folios(params[:service][:client_id])
    unless @folios.include?(folio)
      @folios << folio
      @service = Service.new(service_params)
      @service.user = current_user
      if @service.save
        @message = 'Registro creado exitosamente.'
        render 'create', status: :created
      else
        render 'new', status: :unprocessable_entity
      end
    else
      @service = Service.where(client_id: params[:service][:client_id], folio: folio).first
      @message = 'Servicio encontrado exitosamente.'
      render 'create', status: :ok
    end
  end

  def find_folios
    @folios = Service.find_folios(params[:client][:id].to_i)
  end

  private

  def service_params
    params.require(:service).permit(:client_id, :folio)
  end
end
