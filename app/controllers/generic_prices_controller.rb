class GenericPricesController < ApplicationController
  before_action :check_is_admin, except: [:autocomplete, :search]
  before_action :set_generic_price, only: [:show, :edit, :update, :destroy]
  before_action :fixed_format_price, only: [:create, :update]

  def index
    @generic_prices = GenericPrice
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
    @generic_price = GenericPrice.new
  end

  def edit
  end

  def create
    @generic_price = GenericPrice.new(generic_price_params)

    respond_to do |format|
      if @generic_price.save
        flash[:success] = 'Modelo creado exitosamente.'
        format.html { redirect_to generic_prices_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @generic_price.update(generic_price_params)
        flash[:success] = 'Modelo actualizado correctamente.'
        format.html { redirect_to generic_prices_url }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
      end
    end
  end

  def destroy
    begin
      @generic_price.destroy
      respond_to do |format|
        flash[:success] = 'Modelo eliminado correctamente.'
        format.html { redirect_to generic_prices_url }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = 'El modelo ya esta en uso.'
      redirect_to generic_prices_url
    end
  end

  def autocomplete
    @generic_prices = GenericPrice.search(params[:term]).order(created_at: :desc)
  end

  def search
    @generic_prices = GenericPrice
      .search(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  private

    def set_generic_price
      @generic_price = GenericPrice.find(params[:id])
    end

    def generic_price_params
      params.require(:generic_price).permit(:name, :price)
    end

    def fixed_format_price
        params[:generic_price][:price] = params[:generic_price][:price].gsub(',','')
    end

    def check_is_admin
      unless current_user.admin?
        redirect_to root_path
      end
    end
end
