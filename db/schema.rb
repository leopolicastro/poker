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

ActiveRecord::Schema[8.0].define(version: 2025_05_03_023418) do
  create_table "bets", force: :cascade do |t|
    t.integer "player_id", null: false
    t.integer "round_id", null: false
    t.integer "amount", default: 0, null: false
    t.integer "bet_type", default: 0, null: false
    t.integer "state", default: 0, null: false
    t.boolean "answered", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_bets_on_player_id"
    t.index ["round_id"], name: "index_bets_on_round_id"
  end

  create_table "cards", force: :cascade do |t|
    t.integer "deck_id", null: false
    t.string "cardable_type"
    t.integer "cardable_id"
    t.integer "position"
    t.string "rank"
    t.string "suit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cardable_type", "cardable_id"], name: "index_cards_on_cardable"
    t.index ["deck_id"], name: "index_cards_on_deck_id"
  end

  create_table "chips", force: :cascade do |t|
    t.float "value"
    t.string "chippable_type"
    t.integer "chippable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chippable_type", "chippable_id"], name: "index_chips_on_chippable"
  end

  create_table "decks", force: :cascade do |t|
    t.string "deckable_type"
    t.integer "deckable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deckable_type", "deckable_id"], name: "index_decks_on_deckable"
  end

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.integer "state", default: 0, null: false
    t.integer "small_blind"
    t.integer "big_blind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "game_id", null: false
    t.boolean "dealer", default: false, null: false
    t.integer "position", default: 0, null: false
    t.integer "table_position", default: 0, null: false
    t.integer "state", default: 0, null: false
    t.boolean "turn", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "current_turn_id", null: false
    t.integer "phase", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_turn_id"], name: "index_rounds_on_current_turn_id"
    t.index ["game_id"], name: "index_rounds_on_game_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.string "name"
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "bets", "players"
  add_foreign_key "bets", "rounds"
  add_foreign_key "cards", "decks"
  add_foreign_key "players", "games"
  add_foreign_key "players", "users"
  add_foreign_key "rounds", "games"
  add_foreign_key "rounds", "players", column: "current_turn_id"
  add_foreign_key "sessions", "users"
end
