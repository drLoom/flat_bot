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

ActiveRecord::Schema[7.0].define(version: 2022_08_11_211145) do
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
    t.index ["date", "id"], name: "index_flats_hist_on_date_and_id", unique: true
    t.index ["date", "object_id"], name: "index_flats_hist_on_date_and_object_id", unique: true
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

end
