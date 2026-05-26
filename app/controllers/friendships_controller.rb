class FriendshipsController < ApplicationController
  rate_limit to: 30,
             within: 1.minute,
             only: :create,
             by: -> { current_user&.id || request.remote_ip },
             with: -> { redirect_to root_path, alert: "Too many friend requests. Slow down." }

  before_action :authenticate_user!

  def create
    receiver = User.find(params[:receiver_id])

    friendship = Friendship.new(
      requester: current_user,
      receiver: receiver,
      status: "pending"
    )

    if friendship.save
      flash[:notice] = "Friend request sent to #{receiver.username}"
    else
      flash[:alert] = friendship.errors.full_messages.join(", ")
    end

    redirect_back(fallback_location: root_path)
  end

  def accept
    friendship = Friendship.find(params[:id])

    if friendship.receiver == current_user
      friendship.accept!
      flash[:notice] = "You and #{friendship.requester.username} are now friends!"
    else
      flash[:alert] = "Not authorized."
    end

    redirect_back(fallback_location: root_path)
  end

  def decline
    friendship = Friendship.find(params[:id])

    if friendship.receiver == current_user
      friendship.destroy
      flash[:notice] = "Friend request declined."
    else
      flash[:alert] = "Not allowed."
    end

    redirect_back(fallback_location: root_path)
  end

  def friends
    @friends = current_user.friends
    @sent_requests = current_user.pending_sent_invitations
    @received_requests = current_user.pending_received_invitations
  end

  def requests
    @requests = current_user.pending_received_invitations
  end
end
