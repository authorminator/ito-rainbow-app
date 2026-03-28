# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_03_26_074515) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "players", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.string "nickname"
    t.string "color"
    t.string "session_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_players_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "code"
    t.integer "status"
    t.integer "cards_per_player"
    t.bigint "host_player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "round_assignments", force: :cascade do |t|
    t.bigint "round_id", null: false
    t.bigint "player_id", null: false
    t.integer "secret_number", null: false
    t.text "clue_text"
    t.boolean "submitted", default: false, null: false
    t.integer "turn_position", null: false
    t.integer "display_order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_round_assignments_on_player_id"
    t.index ["round_id"], name: "index_round_assignments_on_round_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.string "theme"
    t.integer "phase"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_rounds_on_room_id"
  end

  add_foreign_key "players", "rooms"
  add_foreign_key "round_assignments", "players"
  add_foreign_key "round_assignments", "rounds"
  add_foreign_key "rounds", "rooms"
end
