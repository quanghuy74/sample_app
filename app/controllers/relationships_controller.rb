class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    if @user = User.find_by(id: params[:followed_id])
      current_user.follow(@user)
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:warning] = t "user.not_found"
      redirect_to root_path
    end
  end

  def destroy
    if @user = Relationship.find_by(id: params[:id]).followed
      current_user.unfollow(@user)
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:warning] = t "user.relationship_not_found"
      redirect_to root_path
    end
  end
end
