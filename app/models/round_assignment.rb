class RoundAssignment < ApplicationRecord
  belongs_to :round
  belongs_to :player

  validates :secret_number, presence: true
  validates :turn_position, presence: true
  validates :display_order, presence: true

  after_update_commit :broadcast_turn_change, if: :saved_change_to_turn_position?

  private

  def broadcast_turn_change
    broadcast_refresh_later_to round.room
  end
end
