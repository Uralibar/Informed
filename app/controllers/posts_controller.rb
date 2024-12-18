class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :check_post_owner, only: %i[ edit update destroy ]
  before_action :check_agency_permissions, only: %i[new create edit update destroy]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
    @top_posts = Post.left_joins(:votes).group("posts.id").order(Arel.sql("COALESCE(SUM(votes.value), 0) DESC")).limit(5)

    @sort = params[:sort]

    @posts = case @sort
    when "most_upvoted"
      Post.left_joins(:votes)
          .group("posts.id")
          .order(Arel.sql("COALESCE(SUM(votes.value), 0) DESC"))
    when "most_downvoted"
      Post.left_joins(:votes)
          .group("posts.id")
          .order(Arel.sql("COALESCE(SUM(votes.value), 0) ASC"))
    when "newest"
      Post.order(created_at: :desc)
    when "oldest"
      Post.order(created_at: :asc)
    else
      Post.order(created_at: :desc)
    end
  end

  # GET /user_posts
  def user_posts
    @posts = current_user.posts
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def upvote
    handle_vote(1, "Upvote removed!", "Upvoted successfully!")
  end

  def downvote
    handle_vote(-1, "Downvote removed!", "Downvoted successfully!")
  end


  private

    def set_post
      @post = Post.find(params[:id])
    end

    def check_post_owner
      unless @post.user == current_user
        redirect_to posts_path, alert: "You can only edit or delete your own posts."
      end
    end

    def post_params
      params.require(:post).permit(:title, :content, :image)
    end

    def check_agency_permissions
      unless current_user.agency?
        redirect_to posts_path, alert: "You are not authorized to perform this action."
      end
    end
    def handle_vote(value, remove_message, add_message)
      post = Post.find(params[:id])
      vote = post.votes.find_by(user: current_user)

      if vote&.value == value
        vote.destroy
        redirect_to request.referer || posts_path, notice: remove_message
      else
        vote = post.votes.find_or_initialize_by(user: current_user)
        vote.value = value
        vote.save
        redirect_to request.referer || posts_path, notice: add_message
      end
    end
end
