class AddLeftAtToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :left_at, :datetime
  end
end
