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

ActiveRecord::Schema[7.0].define(version: 2023_07_03_141313) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "time_event_pairs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "ci_time_event_id", null: false
    t.bigint "co_time_event_id"
    t.datetime "time_spent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ci_time_event_id"], name: "index_time_event_pairs_on_ci_time_event_id"
    t.index ["co_time_event_id"], name: "index_time_event_pairs_on_co_time_event_id"
    t.index ["user_id"], name: "index_time_event_pairs_on_user_id"
  end

  create_table "time_events", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "event_type", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_time_events_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "time_event_pairs", "time_events", column: "ci_time_event_id"
  add_foreign_key "time_event_pairs", "time_events", column: "co_time_event_id"
  add_foreign_key "time_event_pairs", "users"
  add_foreign_key "time_events", "users"
end
