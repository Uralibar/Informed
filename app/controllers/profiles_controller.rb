class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @posts = @user.posts # Fetch the posts belonging to the user
  end

  def find_user_by_username
    @user = User.find_by(username: params[:username])

    if @user
      redirect_to user_profile_path(@user) # Corrected to use user_profile_path
    else
      redirect_to root_path, alert: "User not found" # Show an error message if not found
    end
  end
end
