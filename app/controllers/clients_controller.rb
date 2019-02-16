class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    @clients = Client.order(updated_at: :desc)
  end

  def show
  end

  def new
    @client = Client.new
  end

  def edit
  end

  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        flash[:success] = 'Cliente creado exitosamente.'
        format.html { redirect_to clients_url }
      else
        flash[:error] = 'Proporcione los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @client.update(client_params)
        flash[:success] = 'Cliente actualizado exitosamente.'
        format.html { redirect_to clients_url }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    begin
      @client.destroy
      respond_to do |format|
        flash[:success] = 'Cliente eliminado exitosamente.'
        format.html { redirect_to clients_url }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = "El cliente ya esta en uso."
      redirect_to clients_url
    end
  end

  def autocomplete
    @clients = Client.search(params[:term]).order(created_at: :desc)
  end

  private

    def set_client
      @client = Client.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:name, :first_name, :last_name, :address, :mobile_phone, :home_phone)
    end
end
