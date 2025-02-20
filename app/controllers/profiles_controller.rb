class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])

    @sort = params[:sort]

    @posts = case @sort
    when "most_upvoted"
      @user.posts.left_joins(:votes)
          .group("posts.id")
          .order(Arel.sql("COALESCE(SUM(votes.value), 0) DESC"))
    when "most_downvoted"
      @user.posts.left_joins(:votes)
          .group("posts.id")
          .order(Arel.sql("COALESCE(SUM(votes.value), 0) ASC"))
    when "newest"
      @user.posts.order(created_at: :desc)
    when "oldest"
      @user.posts.order(created_at: :asc)
    else
      @user.posts.order(created_at: :desc)
    end
    @user_comments = @user.comments.order(created_at: :desc)
  end

  def edit
    @user = User.find(params[:id])

    if @user != current_user
      redirect_to user_profile_path(current_user), alert: "You can only edit your own profile."
    end
  end


  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to user_profile_path(@user), notice: "Profile updated successfully."
    else
      render :edit
    end
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

  def delete_profile_picture
    @user = current_user

    if @user.profile_picture.attached?
      @user.profile_picture.purge
      redirect_to edit_user_profile_path(@user), notice: "Profile picture deleted."
    else
      redirect_to edit_user_profile_path(@user), alert: "No profile picture to delete."
    end
  end


  def delete_banner
    @user = current_user

    if @user.banner.attached?
      @user.banner.purge
      redirect_to edit_user_profile_path(@user), notice: "Banner deleted."
    else
      redirect_to edit_user_profile_path(@user), alert: "No banner to delete."
    end
  end

  private

  def user_params
    params.require(:user).permit(:biography, :profile_picture, :banner)
  end
end
