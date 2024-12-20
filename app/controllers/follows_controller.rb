class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    followee = User.find(params[:followee_id])

    if followee.agency?
      current_user.active_follows.create(followee: followee)
      redirect_to user_profile_path(followee), notice: "You are now following #{followee.username}."
    else
      redirect_to user_profile_path(followee), alert: "You can only follow agency users."
    end
  end

  def destroy
    follow = current_user.active_follows.find_by(followee_id: params[:followee_id])
    if follow
      follow.destroy
      redirect_to user_profile_path(User.find(params[:followee_id])), notice: "You have unfollowed this user."
    else
      redirect_to root_path, alert: "Follow record not found."
    end
  end

  def agency_feed
    followees = current_user.followees.where(role: 1)
    @sort = params[:sort]

    case @sort
    when "most_upvoted"
      @posts = Post.left_joins(:votes).where(user_id: followees.ids).group("posts.id") .order(Arel.sql("COALESCE(SUM(votes.value), 0) DESC"))
    when "most_downvoted"
      @posts = Post.left_joins(:votes).where(user_id: followees.ids).group("posts.id").order(Arel.sql("COALESCE(SUM(votes.value), 0) ASC"))
    when "newest"
      @posts = Post.where(user_id: followees.ids).order(created_at: :desc)
    when "oldest"
      @posts = Post.where(user_id: followees.ids).order(created_at: :asc)
    else
      @posts = Post.where(user_id: followees.ids).order(created_at: :desc)
    end
  end
end
