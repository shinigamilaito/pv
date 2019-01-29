class EmployesController < ApplicationController
  def index
    @users = User.order(created_at: :desc)
  end

  def new
    @user = User.new
    @minimum_password_length = 6
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Usuario creado correctamente.'
      redirect_to employes_path
    else
      @minimum_password_length = 6
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @minimum_password_length = 6
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      bypass_sign_in current_user
      flash[:success] = 'Usuario actualizado correctamente.'
      redirect_to employes_path
    else
      @minimum_password_length = 6
      render 'edit'
    end
  end

  def search
    @users = User.search(params[:search]).order(created_at: :desc)
  end

  private

  def user_params
    params.require(:user).permit(:name, :first_name, :last_name, :username, :email, :password, :password_confirmation, :rol_id)
  end
end
