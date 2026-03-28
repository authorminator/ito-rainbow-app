class CreateRounds < ActiveRecord::Migration[7.1]
  def change
    create_table :rounds do |t|
      t.references :room, null: false, foreign_key: true
      t.string :theme, null: false
      t.integer :phase, null: false, default: 0

      t.timestamps
    end
  end
end
