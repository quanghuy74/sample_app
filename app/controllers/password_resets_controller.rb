class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "user_reset_password.email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t "user_reset_password.email_not_found"
      render :new
    end
  end

  def update
    if user_params[:password].empty?
      @user.errors.add(:password, t("user_reset_password.pw_empty"))
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "user_reset_password.success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def get_user
    return if @user = User.find_by(email: params[:email])

    flash[:danger] = t "user_reset_password.email_not_found"
    redirect_to new_password_reset_path
  end

  def valid_user
    return if @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "user_reset_password.incorrect_user"
    redirect_to new_password_reset_path
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end
