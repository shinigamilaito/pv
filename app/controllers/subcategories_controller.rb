class SubcategoriesController < ApplicationController
  before_action :set_subcategory, only: [:show, :edit, :update, :destroy]
  before_action :set_module

  def index
    @subcategories = Subcategory
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
    @subcategory = Subcategory.new
  end

  def edit
  end

  def create
    @subcategory = Subcategory.new(subcategory_params)

    respond_to do |format|
      if @subcategory.save
        flash[:success] = 'Subcategoría creada exitosamente.'
        format.html { redirect_to subcategories_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @subcategory.update(subcategory_params)
        flash[:success] = 'Subcategoría actualizada correctamente.'
        format.html { redirect_to subcategories_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
      end
    end
  end

  def destroy
    begin
      @subcategory.destroy
      respond_to do |format|
        flash[:success] = 'Subcategoría eliminada correctamente.'
        format.html { redirect_to subcategories_url }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = 'El modelo ya esta en uso.'
      redirect_to subcategories_url
    end
  end

  def search
    @subcategories = Subcategory
      .search_index(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  private

    def set_subcategory
      @subcategory = Subcategory.find(params[:id])
    end

    def subcategory_params
      params.require(:subcategory).permit(:category_id, :name, :description)
    end

    def set_module
      @module = "subcategories"
    end
end
