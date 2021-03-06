class SparePartsController < ApplicationController
  before_action :set_spare_part, only: [:show, :edit, :update, :destroy, :translate]
  before_action :fixed_format_price, only: [:create, :update]
  before_action :set_module

  def index
    @spare_parts = SparePart
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
    @spare_part = SparePart.new
  end

  def edit
  end

  def create
    @spare_part = SparePart.new(spare_part_params)

    respond_to do |format|
      if @spare_part.save
        flash[:success] = 'Refacción creada exitosamente.'
        format.html { redirect_to spare_parts_url }
      else
        flash[:error] = 'Proporcione los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @spare_part.update(spare_part_params)
        flash[:success] = 'Refacción actualizada exitosamente.'
        format.html { redirect_to spare_parts_url }
      else
        flash[:error] = 'Proporcione los datos correctos.'
        format.html { render :edit }
      end
    end
  end

  def destroy
    begin
      @spare_part.destroy
      respond_to do |format|
        flash[:success] = 'Refacción eliminada exitosamente.'
        format.html { redirect_to spare_parts_url }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = 'La Refacción ya esta en uso.'
      redirect_to spare_parts_url
    end

  end

  def autocomplete
    @spare_parts = SparePart.search(params[:term]).order(created_at: :desc)
  end

  def search
    @spare_parts = SparePart
      .search(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  def translate
    begin
      translate_items = TranslateItems.new
      translate_items.translate_spare_parts_to_products(@spare_part)
      flash[:notice] = 'Traspaso exitoso.'
      redirect_to spare_parts_url and return
    rescue StandardError => e
      flash[:error] = "#{e.message}"
      redirect_to spare_parts_url and return
    end
  end

  private

    def set_spare_part
      @spare_part = SparePart.find(params[:id])
    end

    def spare_part_params
      params.require(:spare_part).permit(:name, :description, :price_purchase, :price, :total, :code, :stock_minimum)
    end

    def fixed_format_price
      params[:spare_part][:price_purchase] = params[:spare_part][:price_purchase].gsub('$ ', '').gsub(',','')
      params[:spare_part][:price] = params[:spare_part][:price].gsub('$ ', '').gsub(',','')
    end

    def set_module
      @module = "Refacciones"
    end

end
