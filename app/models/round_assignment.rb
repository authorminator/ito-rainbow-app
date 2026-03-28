class RoundAssignment < ApplicationRecord
  belongs_to :round
  belongs_to :player

  validates :secret_number, presence: true
  validates :turn_position, presence: true
  validates :display_order, presence: true
end
