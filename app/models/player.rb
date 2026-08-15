class Player < ApplicationRecord
  belongs_to :room
  has_many :round_assignments, dependent: :destroy

  validates :nickname, presence: true
  validates :color, presence: true
  validates :session_token, presence: true, uniqueness: true

  after_create_commit lambda {
    broadcast_refresh_later_to room
  }
end
