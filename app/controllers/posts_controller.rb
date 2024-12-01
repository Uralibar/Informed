class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[ index show ] # Ensure user is logged in
  before_action :check_post_owner, only: %i[ edit update destroy ] # Ensure users can only edit their own posts
  before_action :check_agency_permissions, only: %i[new create edit update destroy]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /user_posts
  def user_posts
    # Ensure the current_user is present and has posts
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
    @post = current_user.posts.build(post_params) # Associate post with current_user

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

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Ensure only the owner of the post can edit, update, or destroy it
    def check_post_owner
      unless @post.user == current_user
        redirect_to posts_path, alert: "You can only edit or delete your own posts."
      end
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :image)
    end

    def check_agency_permissions
      unless current_user.agency?
        redirect_to posts_path, alert: "You are not authorized to perform this action."
      end
    end
end
