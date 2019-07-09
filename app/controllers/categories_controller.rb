class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :set_module

  def index
    @categories = Category
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
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        flash[:success] = 'Categoría creada exitosamente.'
        format.html { redirect_to categories_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        flash[:success] = 'Categoría actualizada correctamente.'
        format.html { redirect_to categories_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
      end
    end
  end

  def destroy
    begin
      @category.destroy
      respond_to do |format|
        flash[:success] = 'Categoría eliminada correctamente.'
        format.html { redirect_to categories_url }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = 'El modelo ya esta en uso.'
      redirect_to categories_url
    end
  end

  def search
    @categories = Category
      .search_index(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  def subcategories
    @subcategories = Category.find(params[:id]).subcategories
    subcategories_element = render_to_string("invitations/_subcategories_element",
                                             layout: false, locals: {subcategories: @subcategories})

    render json: {
        subcategories: subcategories_element
    }

  end

  private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description)
    end

    def set_module
      @module = "categories"
    end
end
