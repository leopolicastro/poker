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

ActiveRecord::Schema[8.0].define(version: 2025_05_18_124355) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bets", force: :cascade do |t|
    t.integer "player_id", null: false
    t.integer "round_id", null: false
    t.integer "amount", default: 0, null: false
    t.string "type", null: false
    t.integer "state", default: 0, null: false
    t.boolean "answered", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "rotate_turn", default: true, null: false
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
    t.boolean "burn_card", default: false, null: false
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
    t.integer "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_decks_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.integer "state", default: 0, null: false
    t.integer "small_blind"
    t.integer "big_blind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hands", force: :cascade do |t|
    t.integer "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_hands_on_game_id"
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
    t.integer "hand_id", null: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "odds", default: {}, null: false
    t.index ["hand_id"], name: "index_rounds_on_hand_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bets", "players"
  add_foreign_key "bets", "rounds"
  add_foreign_key "cards", "decks"
  add_foreign_key "decks", "games"
  add_foreign_key "hands", "games"
  add_foreign_key "players", "games"
  add_foreign_key "players", "users"
  add_foreign_key "rounds", "hands"
  add_foreign_key "sessions", "users"
end
