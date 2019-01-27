class GenericPricesController < ApplicationController
  before_action :set_generic_price, only: [:show, :edit, :update, :destroy]

  def index
    @generic_prices = GenericPrice.order(updated_at: :desc)
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
        format.json { render :show, status: :created, location: @generic_price }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @generic_price.update(generic_price_params)
        flash[:success] = 'Modelo actualizado correctamente.'
        format.html { redirect_to generic_prices_url }
        format.json { render :show, status: :ok, location: @generic_price }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
        format.json { render json: @generic_price.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      @generic_price.destroy
      respond_to do |format|
        flash[:success] = 'Modelo eliminado correctamente.'
        format.html { redirect_to generic_prices_url }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = 'El modelo ya esta en uso.'
      redirect_to generic_prices_url
    end
  end

  def autocomplete
    @generic_prices = GenericPrice.search(params[:term]).order(created_at: :desc)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_generic_price
      @generic_price = GenericPrice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def generic_price_params
      params.require(:generic_price).permit(:name, :price)
    end
end
