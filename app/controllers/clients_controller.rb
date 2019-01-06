class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.order(updated_at: :desc)
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        flash[:success] = 'Cliente creado exitosamente.'
        format.html { redirect_to clients_url }
        format.json { render :show, status: :created, location: @client }
      else
        flash[:error] = 'Proporcione los datos correctos.'
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        flash[:success] = 'Cliente actualizado exitosamente.'
        format.html { redirect_to clients_url }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    begin
      @client.destroy
      respond_to do |format|
        flash[:success] = 'Cliente eliminado exitosamente.'
        format.html { redirect_to clients_url }
        format.json { head :no_content }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :first_name, :last_name, :address, :mobile_phone, :home_phone)
    end
end
