class UsersController < ApplicationController
  def show
    return if @user = User.find_by(id: params[:id])

    flash[:warning] = t "account.not_find_account"
    redirect_to signup_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params 
    if @user.save
      flash[:success] = t "home_title"
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
