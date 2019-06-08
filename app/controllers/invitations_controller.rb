class InvitationsController < ApplicationController
  before_action :set_invitation, only: [:show, :edit, :update, :destroy]
  before_action :set_module

  def index
    destroy_invitation_printing_products

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
    @invitation_printing_products = invitation_printing_products(nil)
  end

  def edit
    @invitation_printing_products = invitation_printing_products(@invitation)
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.user = current_user
    @invitation.invitation_printing_products = invitation_printing_products_for_save
    respond_to do |format|
      if @invitation.save
        flash[:success] = 'Invitación creada exitosamente.'
        format.html { redirect_to invitations_url }
      else
        @invitation_printing_products = invitation_printing_products(nil)
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    @invitation.name = invitation_params[:name]
    @invitation.imagen = invitation_params[:imagen]
    @invitation.imagen_cache = invitation_params[:imagen_cache]
    respond_to do |format|
      @invitation.invitation_printing_products << invitation_printing_products_for_save
      if @invitation.save
        flash[:success] = 'Invitación actualizada correctamente.'
        format.html { redirect_to invitations_url }
      else
        @invitation_printing_products = invitation_printing_products(@invitation)
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

  def add_printing_product
    printing_product = PrintingProduct.find(params[:printing_product][:id])
    invitation_service = InvitationService.new(printing_product, current_user)
    begin
      invitation_service.create_invitation_printing_product
      invitation_id = params[:invitation_id].to_i
      invitation = invitation_id < 0 ? nil : Invitation.find(invitation_id)
      @invitation_printing_products = invitation_printing_products(invitation)
    rescue StandardError => e
      render js: "toastr['error']('#{e.message}');", status: :bad_request
    end
  end

  def delete_invitation_printing_product
    begin
      @invitation_printing_product = InvitationPrintingProduct.find(params[:id])
      @invitation_printing_product.destroy
      respond_to do |format|
        flash[:success] = 'Producto eliminado correctamente.'
        format.js do
          invitation_id = params[:invitation_id].to_i
          invitation = invitation_id < 0 ? nil : Invitation.find(invitation_id)
          @invitation_printing_products = invitation_printing_products(invitation)
          render "invitations/add_printing_product"
        end
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = 'El producto ya esta en uso.'
      redirect_to invitations_url
    end
  end

  def obtain_printing_products
    invitation = Invitation.find(params[:invitation_id])
    @printing_products = invitation.invitation_printing_products
  end

  private

    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    def invitation_params
      params.require(:invitation).permit(:name, :imagen, :imagen_cache)
    end

    def set_module
      @module = "Invitaciones"
    end

    def invitation_printing_products_for_save
      current_user.invitation_printing_products.where(invitation_id: nil)
    end

    def invitation_printing_products(invitation)
      if invitation.present?
        current_user.invitation_printing_products.where(invitation_id: nil) + current_user.invitation_printing_products.where(invitation_id: invitation.id)
      else
        current_user.invitation_printing_products.where(invitation_id: nil)
      end
    end

    def destroy_invitation_printing_products
      invitation_printing_products_for_save.each do |invitation_printing_product|
        invitation_printing_product.destroy
      end
    end
end
