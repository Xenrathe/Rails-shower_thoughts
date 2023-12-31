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

ActiveRecord::Schema[7.0].define(version: 2023_10_09_124144) do
  create_table "thoughts", force: :cascade do |t|
    t.datetime "post_time"
    t.string "title"
    t.string "content"
    t.string "highlight_mode"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["highlight_mode"], name: "index_thoughts_on_highlight_mode"
    t.index ["user_id"], name: "index_thoughts_on_user_id"
  end

  create_table "user_favorite_thoughts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "thought_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thought_id"], name: "index_user_favorite_thoughts_on_thought_id"
    t.index ["user_id"], name: "index_user_favorite_thoughts_on_user_id"
  end

  create_table "user_hidden_thoughts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "thought_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thought_id"], name: "index_user_hidden_thoughts_on_thought_id"
    t.index ["user_id"], name: "index_user_hidden_thoughts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "last_post_date"
    t.datetime "plumber_date"
    t.string "username", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "plumber_status", default: "No"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "thoughts", "users"
  add_foreign_key "user_favorite_thoughts", "thoughts"
  add_foreign_key "user_favorite_thoughts", "users"
  add_foreign_key "user_hidden_thoughts", "thoughts"
  add_foreign_key "user_hidden_thoughts", "users"
end
