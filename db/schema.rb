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

ActiveRecord::Schema[7.0].define(version: 2023_01_10_140131) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "flats_hist", force: :cascade do |t|
    t.date "date"
    t.bigint "object_id"
    t.decimal "area", precision: 6, scale: 2
    t.decimal "price", precision: 10, scale: 2
    t.decimal "price_usd", precision: 10, scale: 2
    t.float "rooms"
    t.string "url"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "internal_id"
    t.bigint "img_id"
    t.index ["date", "id"], name: "index_flats_hist_on_date_and_id", unique: true
    t.index ["date", "object_id"], name: "index_flats_hist_on_date_and_object_id", unique: true
    t.index ["object_id", "date"], name: "index_flats_hist_on_object_id_and_date"
  end

  create_table "stars", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "object_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "object_id"], name: "index_stars_on_user_id_and_object_id", unique: true
  end

  create_table "t_users", force: :cascade do |t|
    t.bigint "tid"
    t.boolean "is_bot"
    t.string "first_name"
    t.string "username"
    t.string "language_code"
    t.bigint "chat_id"
    t.string "chat_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tid", "chat_id"], name: "index_t_users_on_tid_and_chat_id", unique: true
  end

  create_table "t_usser_notifications", force: :cascade do |t|
    t.bigint "t_user_id"
    t.string "rooms"
    t.string "meters"
    t.string "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ntype"
    t.string "price_direction"
    t.index ["t_user_id"], name: "index_t_usser_notifications_on_t_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
