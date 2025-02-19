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

ActiveRecord::Schema[7.1].define(version: 0) do
  create_table "admins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "password", null: false
    t.string "role", null: false
  end

  create_table "cities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
  end

  create_table "club_managers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "club_id", null: false
    t.string "role", null: false
  end

  create_table "clubs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "country_id", null: false
    t.integer "city_id", null: false
    t.integer "district_id", null: false
    t.integer "street_id", null: false
  end

  create_table "countries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
  end

  create_table "districts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
  end

  create_table "nearby_parties", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "player_id", null: false
    t.integer "party_id", null: false
    t.integer "distance", null: false
  end

  create_table "parties", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "captain_id", null: false
    t.integer "club_id", null: false
  end

  create_table "party_participants", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "party_id", null: false
    t.integer "player_id", null: false
  end

  create_table "players", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "country_id", null: false
    t.integer "city_id", null: false
    t.integer "district_id", null: false
    t.integer "street_id", null: false
  end

  create_table "streets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
  end

end
