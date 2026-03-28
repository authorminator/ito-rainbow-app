class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.references :room, null: false, foreign_key: true
      t.string :nickname, null: false
      t.string :color, null: false
      t.string :session_token, null: false

      t.timestamps
    end

    add_index :players, :session_token, unique: true
  end
end
