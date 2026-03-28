class CreateRoundAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :round_assignments do |t|
      t.references :round, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.integer :secret_number, null: false
      t.text :clue_text
      t.boolean :submitted, null: false, default: false
      t.integer :turn_position, null: false
      t.integer :display_order, null: false

      t.timestamps
    end
  end
end
