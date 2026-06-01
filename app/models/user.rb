class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :timeoutable,
         :confirmable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy

  validates :username, presence: true
  validate :password_complexity, if: -> { password.present? }

  PASSWORD_COMPLEXITY = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}\z/

  enum :role, { trainee: 0, admin: 1 }

  has_many :sent_friendships,
          class_name: "Friendship",
          foreign_key: "requester_id",
          dependent: :destroy

  has_many :received_friendships,
          class_name: "Friendship",
          foreign_key: "receiver_id",
          dependent: :destroy

  def friends
    sent_friendships.where(status: "accepted").map(&:receiver) +
    received_friendships.where(status: "accepted").map(&:requester)
  end

  def pending_sent_invitations
    sent_friendships.where(status: "pending")
  end

  def pending_received_invitations
    received_friendships.where(status: "pending")
  end

  def timed_out?
    timeout_until.present? && timeout_until > Time.current
  end

  private

  def password_complexity
    return if password.match?(PASSWORD_COMPLEXITY)

    errors.add(
      :password,
      "must include at least one uppercase letter, one lowercase letter, and one number (minimum 6 characters)"
    )
  end
end
