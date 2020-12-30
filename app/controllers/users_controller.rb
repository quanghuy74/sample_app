class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page],
      per_page: Settings.page.per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "email_active.check"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "user_edit.success"
      redirect_to @user
    else
      flash.now[:danger] = t "edit_user.fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_delete.deleted"
    else
      flash[:danger] = t "edit_delete.fail"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "user_login.please_login"
    redirect_to login_path
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t "user_edit.correct_user"
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "user_delete.not_admin"
    redirect_to root_url
  end

  def find_user
    return if @user = User.find_by(id: params[:id])

    flash[:warning] = t "account.not_find_account"
    redirect_to root_path
  end
end
