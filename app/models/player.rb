class Player < ApplicationRecord
  belongs_to :room
  has_many :round_assignments

  validates :nickname, presence: true
  validates :color, presence: true
  validates :session_token, presence: true, uniqueness: true
  scope :active, -> { where(left_at: nil) }

  after_create_commit lambda {
    broadcast_refresh_later_to room
  }

  after_destroy_commit lambda {
    broadcast_refresh_later_to room
  }

  after_update_commit :broadcast_leave_change, if: :saved_change_to_left_at?

  private

  def broadcast_leave_change
    broadcast_refresh_later_to room
  end
end
