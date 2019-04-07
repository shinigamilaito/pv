class EquipmentModelsController < ApplicationController
  before_action :set_equipment_model, only: [:show, :edit, :update, :destroy]

  def index
    @equipment_models = EquipmentModel
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(updated_at: :desc)

    @index = obtain_index(params[:page].to_i)

    respond_to do |format|
      format.html { render :index }
      format.js { render :search }
    end
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
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @equipment_model.update(equipment_model_params)
        flash[:success] = 'Modelo actualizado correctamente.'
        format.html { redirect_to equipment_models_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
      end
    end
  end

  def destroy
    begin
      @equipment_model.destroy
      respond_to do |format|
        flash[:success] = 'Modelo eliminado correctamente.'
        format.html { redirect_to equipment_models_url }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = 'El modelo ya esta en uso.'
      redirect_to equipment_models_url
    end
  end

  def autocomplete
    @equipment_models = EquipmentModel.search(params[:term]).order(created_at: :desc)
  end

  def search
    @equipment_models = EquipmentModel
      .search_index(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  private

    def set_equipment_model
      @equipment_model = EquipmentModel.find(params[:id])
    end

    def equipment_model_params
      params.require(:equipment_model).permit(:name, :description)
    end  
end
