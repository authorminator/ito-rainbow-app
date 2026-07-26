class Room < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :rounds, dependent: :destroy

  enum :status, { lobby: 0, in_round: 1 }

  validates :code, presence: true, uniqueness: true
  validates :cards_per_player, presence: true, inclusion: { in: [1, 2, 3] }

  def host
    players.find_by(id: host_player_id)
  end

end
