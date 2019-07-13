class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]
  before_action :set_module

  def index
    @invitations = Invitation
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
    @invitation = Invitation.new
    @subcategories = []
  end

  def edit
    subcategories
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.user = current_user

    respond_to do |format|
      if @invitation.save
        flash[:success] = 'Invitación creada exitosamente.'
        format.html { redirect_to invitations_url }
      else
        subcategories
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @invitation.update(invitation_params)
        flash[:success] = 'Invitación actualizada correctamente.'
        format.html { redirect_to invitations_url }
      else
        subcategories
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
      end
    end
  end

  def destroy
    begin
      @invitation.destroy
      respond_to do |format|
        flash[:success] = 'Invitación eliminada correctamente.'
        format.html { redirect_to invitations_url }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = 'La invitación ya esta en uso.'
      redirect_to invitations_url
    end
  end

  def autocomplete
    @invitations = Invitation.search(params[:term]).order(created_at: :desc)
  end

  def search
    @invitations = Invitation
      .search(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  private

    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    def invitation_params
      params.require(:invitation).permit(:description, :name, :imagen, :imagen_cache, :category_id, :subcategory_id)
    end

    def set_module
      @module = "Invitaciones"
    end

    def subcategories
      @subcategories = @invitation.category.subcategories
    end

end
