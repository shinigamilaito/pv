class EquipmentsController < ApplicationController
  before_action :set_equipment, only: [:show, :edit, :update, :destroy]
  before_action :set_module

  def index
    @equipments = Equipment
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
    @equipment = Equipment.new
  end

  def edit
  end

  def create
    @equipment = Equipment.new(equipment_params)

    respond_to do |format|
      if @equipment.save
        flash[:success] = 'Equipo creado exitosamente.'
        format.html { redirect_to equipments_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @equipment.update(equipment_params)
        flash[:success] = 'Equipo actualizado exitosamente.'
        format.html { redirect_to equipments_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
      end
    end
  end

  def destroy
    begin
      @equipment.destroy
      respond_to do |format|
        flash[:success] = 'Equipo eliminado exitosamente.'
        format.html { redirect_to equipments_url }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = 'El equipo ya esta en uso.'
      redirect_to equipments_url
    end
  end

  def autocomplete
    @equipments = Equipment.search(params[:term]).order(created_at: :desc)
  end

  def search
    @equipments = Equipment
      .search_index(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  private

    def set_equipment
      @equipment = Equipment.find(params[:id])
    end

    def equipment_params
      params.require(:equipment).permit(:name, :specifications, :imagen)
    end

    def set_module
      @module = "Equipos"
    end

end
