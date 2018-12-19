class SparePartsController < ApplicationController
  before_action :set_spare_part, only: [:show, :edit, :update, :destroy]

  # GET /spare_parts
  # GET /spare_parts.json
  def index
    @spare_parts = SparePart.all
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
        format.html { redirect_to @spare_part, notice: 'Spare part was successfully created.' }
        format.json { render :show, status: :created, location: @spare_part }
      else
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
        format.html { redirect_to @spare_part, notice: 'Spare part was successfully updated.' }
        format.json { render :show, status: :ok, location: @spare_part }
      else
        format.html { render :edit }
        format.json { render json: @spare_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spare_parts/1
  # DELETE /spare_parts/1.json
  def destroy
    @spare_part.destroy
    respond_to do |format|
      format.html { redirect_to spare_parts_url, notice: 'Spare part was successfully destroyed.' }
      format.json { head :no_content }
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
end
