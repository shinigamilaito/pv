class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]
  before_action :set_module

  def index
    @brands = Brand
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
    @brand = Brand.new
  end

  def edit
  end

  def create
    @brand = Brand.new(brand_params)

    respond_to do |format|
      if @brand.save
        flash[:success] = 'Marca creada exitosamente.'
        format.html { redirect_to brands_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @brand.update(brand_params)
        flash[:success] = 'Marca actualizada correctamente.'
        format.html { redirect_to brands_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
      end
    end
  end

  def destroy
    begin
      @brand.destroy
      respond_to do |format|
        flash[:success] = 'Marca eliminada correctamente.'
        format.html { redirect_to brands_url }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = 'La marca ya esta en uso.'
      redirect_to brands_url
    end
  end

  def autocomplete
    @brands = Brand.search(params[:term]).order(created_at: :desc)
  end

  def search
    @brands = Brand
      .search_index(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  private

    def set_brand
      @brand = Brand.find(params[:id])
    end

    def brand_params
      params.require(:brand).permit(:name, :specifications)
    end

    def set_module
      @module = "Marcas"
    end
end
