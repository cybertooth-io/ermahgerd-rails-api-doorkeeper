# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_18_035723) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sessions", force: :cascade do |t|
    t.string "browser", null: false
    t.string "browser_version", null: false
    t.string "device", null: false
    t.datetime "expiring_at", null: false
    t.boolean "invalidated", default: false, null: false
    t.bigint "invalidated_by_id"
    t.inet "ip_address", null: false
    t.string "platform", null: false
    t.string "platform_version", null: false
    t.string "ruid", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invalidated_by_id"], name: "index_sessions_on_invalidated_by_id"
    t.index ["ruid"], name: "index_sessions_on_ruid"
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "nickname"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "sessions", "users"
  add_foreign_key "sessions", "users", column: "invalidated_by_id"
end
