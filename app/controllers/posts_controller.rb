class PostsController < ApplicationController
  POSTS_PER_PAGE = 10
  COMMENTS_PER_PAGE = 10

  rate_limit to: 10,
             within: 1.minute,
             only: :create,
             by: -> { current_user&.id || request.remote_ip },
             with: -> { redirect_to posts_path, alert: "You are posting too quickly. Slow down." }

  before_action :authenticate_user!
  before_action :set_post, only: [:show, :destroy]
  before_action :authorize_destroy!, only: [:destroy]

  def index
    @skills = Skill.order(:name)

    base = Post
             .includes(:user, :comments, :ratings, :skills, media_attachments: :blob)
             .order(created_at: :desc)

    if params[:skill_id].present?
      @selected_skill = Skill.find(params[:skill_id])
      base = base.joins(:skills).where(skills: { id: @selected_skill.id }).distinct
    end

    @page = [params[:page].to_i, 1].max
    @total_count = base.except(:order).count
    @total_pages = [(@total_count.to_f / POSTS_PER_PAGE).ceil, 1].max
    @page = @total_pages if @page > @total_pages

    @posts = base.offset((@page - 1) * POSTS_PER_PAGE).limit(POSTS_PER_PAGE)
  end

  def new
    @post = Post.new
    @skills = Skill.order(:name)
  end

  def create
    if current_user.timed_out?
      redirect_to posts_path, alert: "You are temporarily blocked from posting"
      return
    end

    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to posts_path, notice: "Post created"
    else
      @skills = Skill.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @comment = Comment.new

    comments_base = @post.comments.includes(:user).order(created_at: :desc)
    @comments_total = comments_base.count

    @page = [params[:page].to_i, 1].max
    @total_pages = [(@comments_total.to_f / COMMENTS_PER_PAGE).ceil, 1].max
    @page = @total_pages if @page > @total_pages

    @comments = comments_base
                  .offset((@page - 1) * COMMENTS_PER_PAGE)
                  .limit(COMMENTS_PER_PAGE)
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post deleted"
  end

  private

  def set_post
    @post = Post.includes(:skills, :ratings, :comments, media_attachments: :blob)
                .find(params[:id])
  end

  def authorize_destroy!
    return if current_user.admin? || @post.user == current_user
    redirect_to posts_path, alert: "You are not allowed to delete this post"
  end

  def post_params
    params.require(:post).permit(:content, media: [], skill_ids: [])
  end
end
