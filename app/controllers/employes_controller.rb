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
      flash[:success] = "Usuario creado correctamente."
      redirect_to employes_path
    else
        @minimum_password_length = 6
      p @user.errors
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @minimum_password_length = 6
  end

  def update
    @user = User.find(params[:id])
    if params[:password].blank?
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
    if @user.update(user_params)
      flash[:success] = "Usuario actualizado correctamente."
      redirect_to employes_path
    else
        @minimum_password_length = 6
      p @user.errors.full_messages
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :first_name, :last_name, :username, :email, :password, :password_confirmation, :rol_id)
  end
end
