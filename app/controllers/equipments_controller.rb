class EquipmentsController < ApplicationController
  before_action :set_equipment, only: [:show, :edit, :update, :destroy]
  
  # GET /equipment
  # GET /equipment.json
  def index
    @equipments = Equipment.order(updated_at: :desc)
  end

  # GET /equipment/1
  # GET /equipment/1.json
  def show
  end

  # GET /equipment/new
  def new
    @equipment = Equipment.new
  end

  # GET /equipment/1/edit
  def edit
  end

  # POST /equipment
  # POST /equipment.json
  def create
    @equipment = Equipment.new(equipment_params)

    respond_to do |format|
      if @equipment.save
        flash[:success] = 'Equipo creado exitosamente.'
        format.html { redirect_to equipments_url }
        format.json { render :show, status: :created, location: @equipment }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipment/1
  # PATCH/PUT /equipment/1.json
  def update
    respond_to do |format|
      if @equipment.update(equipment_params)
        flash[:success] = 'Equipo actualizado exitosamente.'
        format.html { redirect_to equipments_url }
        format.json { render :show, status: :ok, location: @equipment }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipment/1
  # DELETE /equipment/1.json
  def destroy
    begin
      @equipment.destroy
      respond_to do |format|
        flash[:success] = 'Equipo eliminado exitosamente.'
        format.html { redirect_to equipments_url }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = "El equipo ya esta en uso."
      redirect_to equipments_url
    end
  end

  def autocomplete
    @equipments = Equipment.search(params[:term]).order(created_at: :desc)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipment
      @equipment = Equipment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipment_params
      params.require(:equipment).permit(:name, :specifications)
    end

    def equipment_in_use
      redirect_to equipments_url
    end
end
