class CommentsController < ApplicationController
  rate_limit to: 20,
             within: 1.minute,
             only: :create,
             by: -> { current_user&.id || request.remote_ip },
             with: -> { redirect_to posts_path, alert: "You are commenting too quickly. Slow down." }

  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:destroy]
  before_action :authorize_destroy!, only: [:destroy]

  def create
    if current_user.timed_out?
      redirect_to post_path(@post), alert: "You are temporarily blocked from commenting"
      return
    end

    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post), notice: "Comment added"
    else
      redirect_to post_path(@post), alert: "Comment cannot be empty"
    end
  end

  def destroy
    @comment.destroy
    redirect_to post_path(@post), notice: "Comment deleted"
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def authorize_destroy!
    return if current_user.admin? || @comment.user == current_user
    redirect_to post_path(@post), alert: "You are not allowed to delete this comment"
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
