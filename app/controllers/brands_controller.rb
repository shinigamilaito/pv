class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]

  # GET /brands
  # GET /brands.json
  def index
    @brands = Brand.order(updated_at: :desc)
  end

  # GET /brands/1
  # GET /brands/1.json
  def show
  end

  # GET /brands/new
  def new
    @brand = Brand.new
  end

  # GET /brands/1/edit
  def edit
  end

  # POST /brands
  # POST /brands.json
  def create
    @brand = Brand.new(brand_params)

    respond_to do |format|
      if @brand.save
        flash[:success] = 'Marca creada exitosamente.'
        format.html { redirect_to brands_url }
        format.json { render :show, status: :created, location: @brand }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /brands/1
  # PATCH/PUT /brands/1.json
  def update
    respond_to do |format|
      if @brand.update(brand_params)
        flash[:success] = 'Marca actualizada correctamente.'
        format.html { redirect_to brands_url }
        format.json { render :show, status: :ok, location: @brand }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.json
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
    @brands = Brand.search_index(params[:search]).order(created_at: :desc)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brand
      @brand = Brand.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brand_params
      params.require(:brand).permit(:name, :specifications)
    end
end
