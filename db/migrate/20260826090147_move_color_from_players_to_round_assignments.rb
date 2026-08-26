class MoveColorFromPlayersToRoundAssignments < ActiveRecord::Migration[7.1]
  def change
    remove_column :players, :color, :string
    add_column :round_assignments, :color, :string, null: false, default: 'blue'
  end
end
