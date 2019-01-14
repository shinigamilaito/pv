class SparePartsController < ApplicationController
  before_action :set_spare_part, only: [:show, :edit, :update, :destroy]
  before_action :fixed_format_price, only: [:create, :update]

  # GET /spare_parts
  # GET /spare_parts.json
  def index
    @spare_parts = SparePart.order(updated_at: :desc)
  end

  # GET /spare_parts/1
  # GET /spare_parts/1.json
  def show
  end

  # GET /spare_parts/new
  def new
    @spare_part = SparePart.new
  end

  # GET /spare_parts/1/edit
  def edit
  end

  # POST /spare_parts
  # POST /spare_parts.json
  def create
    @spare_part = SparePart.new(spare_part_params)

    respond_to do |format|
      if @spare_part.save
        flash[:success] = 'Refacción creada exitosamente.'
        format.html { redirect_to spare_parts_url }
        format.json { render :show, status: :created, location: @spare_part }
      else
        flash[:error] = 'Proporcione los datos correctos.'
        format.html { render :new }
        format.json { render json: @spare_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spare_parts/1
  # PATCH/PUT /spare_parts/1.json
  def update
    respond_to do |format|
      if @spare_part.update(spare_part_params)
        flash[:success] = 'Refacción actualizada exitosamente.'
        format.html { redirect_to spare_parts_url }
        format.json { render :show, status: :ok, location: @spare_part }
      else
        flash[:error] = 'Proporcione los datos correctos.'
        format.html { render :edit }
        format.json { render json: @spare_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spare_parts/1
  # DELETE /spare_parts/1.json
  def destroy
    begin
      @spare_part.destroy
      respond_to do |format|
        flash[:success] = 'Refacción eliminada exitosamente.'
        format.html { redirect_to spare_parts_url }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = 'La Refacción ya esta en uso.'
      redirect_to spare_parts_url
    end

  end

  def autocomplete
    @spare_parts = SparePart.search(params[:term]).order(created_at: :desc)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spare_part
      @spare_part = SparePart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spare_part_params
      params.require(:spare_part).permit(:name, :description, :price, :total)
    end

    def fixed_format_price
        params[:spare_part][:price] = params[:spare_part][:price].gsub('$ ', '').gsub(',','')
    end

end
