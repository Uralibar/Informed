class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def find_user_by_username
    @user = User.find_by(username: params[:username])

    if @user
      redirect_to user_profile_path(@user)
    else
      if params[:redirect_to_agency_search] == "true"
        redirect_to search_agency_users_path(query: params[:username])
      else
        redirect_to root_path, alert: "User not found."
      end
    end
  end

  def search_agency_users
    @agency_users = User.where("username LIKE ? AND role = ?", "%#{params[:query]}%", 1)

    render "profiles/agency_search_results"
  end
end
