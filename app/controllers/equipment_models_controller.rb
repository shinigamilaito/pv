class EquipmentModelsController < ApplicationController
  before_action :set_equipment_model, only: [:show, :edit, :update, :destroy]

  def index
    @equipment_models = EquipmentModel.order(updated_at: :desc)
  end

  def show
  end

  def new
    @equipment_model = EquipmentModel.new
  end

  def edit
  end

  def create
    @equipment_model = EquipmentModel.new(equipment_model_params)

    respond_to do |format|
      if @equipment_model.save
        flash[:success] = 'Modelo creado exitosamente.'
        format.html { redirect_to equipment_models_url }
        format.json { render :show, status: :created, location: @equipment_model }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @equipment_model.update(equipment_model_params)
        flash[:success] = 'Modelo actualizado correctamente.'
        format.html { redirect_to equipment_models_url }
        format.json { render :show, status: :ok, location: @equipment_model }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
        format.json { render json: @equipment_model.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      @equipment_model.destroy
      respond_to do |format|
        flash[:success] = 'Modelo eliminado correctamente.'
        format.html { redirect_to equipment_models_url }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = 'El modelo ya esta en uso.'
      redirect_to equipment_models_url
    end
  end

  def autocomplete
    @equipment_models = EquipmentModel.search(params[:term]).order(created_at: :desc)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipment_model
      @equipment_model = EquipmentModel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipment_model_params
      params.require(:equipment_model).permit(:name, :description)
    end
end