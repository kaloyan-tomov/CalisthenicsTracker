class RatingsController < ApplicationController
  rate_limit to: 20,
             within: 1.minute,
             only: :create,
             by: -> { current_user&.id || request.remote_ip },
             with: -> { redirect_to posts_path, alert: "You are rating too quickly. Slow down." }

  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_post

  def create
    if current_user.timed_out?
      redirect_to post_path(@post), alert: "You are temporarily blocked from rating"
      return
    end

    @rating = @post.ratings.find_or_initialize_by(user: current_user)
    @rating.assign_attributes(rating_params)

    if @rating.save
      redirect_to post_path(@post), notice: "Rating saved"
    else
      redirect_to post_path(@post), alert: @rating.errors.full_messages.first
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def rating_params
    params.require(:rating).permit(:score, :comment)
  end

  def require_admin!
    return if current_user&.admin?
    redirect_to posts_path, alert: "Only admins can rate posts"
  end
end
