class Round < ApplicationRecord
  belongs_to :room
  has_many :round_assignments, dependent: :destroy

  enum :phase, { turn: 0, arranging: 1, revealed: 2 }

  validates :theme, presence: true

  def current_assignment
    round_assignments
      .where(submitted: false)
      .order(:turn_position)
      .first
  end

  def submitted_assignments
    round_assignments
      .where(submitted: true)
      .order(:display_order)
  end

  def successful?
    submitted_assignments.to_a == round_assignments.order(:secret_number).to_a
  end
end
