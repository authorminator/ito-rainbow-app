class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :code, null: false
      t.integer :status, null: false, default: 0
      t.integer :cards_per_player, null: false, default: 1
      t.bigint :host_player_id

      t.timestamps

    end

    add_index :rooms, :code, unique: true
  end
end
