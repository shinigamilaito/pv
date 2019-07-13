class ContentForInvitationsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]
  before_action :set_module

  def index
    @content_for_invitations = ContentForInvitation
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
    @content_for_invitation = ContentForInvitation.new
    @subcategories = []
  end

  def edit
    subcategories
  end

  def create
    @content_for_invitation = ContentForInvitation.new(content_for_invitation_params)

    respond_to do |format|
      if @content_for_invitation.save
        flash[:success] = 'Contenido creado exitosamente.'
        format.html { redirect_to content_for_invitations_url }
      else
        subcategories
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @content_for_invitation.update(content_for_invitation_params)
        flash[:success] = 'Contenido actualizado correctamente.'
        format.html { redirect_to content_for_invitations_url }
      else
        subcategories
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
      end
    end
  end

  def destroy
    begin
      @content_for_invitation.destroy
      respond_to do |format|
        flash[:success] = 'Contenido eliminado correctamente.'
        format.html { redirect_to invitations_url }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => e
      logger.debug("Failed to deleted printing product #{e}")
      flash[:error] = 'El contenido ya esta en uso.'
      redirect_to content_for_invitations_url
    end
  end

  def search
    @content_for_invitations = ContentForInvitation
      .search(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  private

    def set_content
      @content_for_invitation = ContentForInvitation.find(params[:id])
    end

    def content_for_invitation_params
      params.require(:content_for_invitation).permit(:description, :name, :image, :image_cache,
                                                     :category_id, :subcategory_id)
    end

    def set_module
      @module = "content_for_invitations"
    end

    def subcategories
      @subcategories = @content_for_invitation.category.subcategories
    end

end
