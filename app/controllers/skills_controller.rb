class SkillsController < ApplicationController
  POSTS_PER_PAGE = 10

  before_action :authenticate_user!
  before_action :set_skill, only: [:show]

  def index
    @skills = Skill
                .includes(posts: :ratings)
                .order(:name)
  end

  def show
    base = @skill.posts
                 .includes(:user, :skills, :ratings, media_attachments: :blob)
                 .order(created_at: :desc)

    @page = [params[:page].to_i, 1].max
    @total_count = base.except(:order).count
    @total_pages = [(@total_count.to_f / POSTS_PER_PAGE).ceil, 1].max
    @page = @total_pages if @page > @total_pages

    @posts = base.offset((@page - 1) * POSTS_PER_PAGE).limit(POSTS_PER_PAGE)
  end

  private

  def set_skill
    @skill = Skill.find(params[:id])
  end
end
