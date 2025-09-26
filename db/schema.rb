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

ActiveRecord::Schema[8.0].define(version: 2025_09_26_123122) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attending_physicians", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bmr_records", force: :cascade do |t|
    t.float "mifflin_st_jeor"
    t.float "harris_benedict"
    t.bigint "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_bmr_records_on_patient_id"
  end

  create_table "patient_attending_physicians", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "attending_physician_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attending_physician_id"], name: "index_patient_attending_physicians_on_attending_physician_id"
    t.index ["patient_id", "attending_physician_id"], name: "index_patient_physicians_on_patient_and_physician", unique: true
    t.index ["patient_id"], name: "index_patient_attending_physicians_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.date "birthday", null: false
    t.integer "gender", default: 0, null: false
    t.float "height", null: false
    t.float "weight", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name", "last_name", "middle_name", "birthday"], name: "index_patients_on_name_and_birthday", unique: true
  end

  add_foreign_key "bmr_records", "patients"
  add_foreign_key "patient_attending_physicians", "attending_physicians"
  add_foreign_key "patient_attending_physicians", "patients"
end
