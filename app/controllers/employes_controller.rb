class EmployesController < ApplicationController
  before_action :check_is_admin, except: [:search]

  def index
    @users = User
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)

    respond_to do |format|
      format.html { render :index }
      format.js { render :search }
    end
  end

  def new
    @user = User.new
    set_minimum_password
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Usuario creado correctamente.'
      redirect_to employes_path
    else
      set_minimum_password
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    set_minimum_password
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      bypass_sign_in current_user
      flash[:success] = 'Usuario actualizado correctamente.'
      redirect_to employes_path
    else
      set_minimum_password
      render 'edit'
    end
  end

  def search
    @users = User
      .search(params[:search])
      .paginate(page: params[:page], per_page: self.elements_per_page)
      .order(created_at: :desc)

    @index = obtain_index(params[:page].to_i)
  end

  def autocomplete
    @users = User.search_autocomplete(params[:term]).order(created_at: :desc)
  end

  private

  def user_params
    params.require(:user).permit(:name, :first_name, :last_name, :username, :email, :password, :password_confirmation, :rol_id)
  end

  def set_minimum_password
    @minimum_password_length = 6
  end

  def check_is_admin
    unless current_user.admin?
      redirect_to root_path
    end
  end
end
