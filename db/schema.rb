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

ActiveRecord::Schema[7.1].define(version: 2024_05_23_183312) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", primary_key: "client_uid", id: :uuid, default: nil, force: :cascade do |t|
    t.string "client_name", limit: 150

    t.unique_constraint ["client_name"], name: "clients_client_name_key"
  end

  create_table "contacts", primary_key: "contact_uid", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid "client_uid", null: false
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.string "email", limit: 100, null: false
    t.string "phone", limit: 20

    t.unique_constraint ["email"], name: "contacts_email_key"
    t.unique_constraint ["phone"], name: "contacts_phone_key"
  end

  create_table "control_points", primary_key: "cp_uid", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid "op_uid", null: false
    t.string "cp_name", limit: 100, null: false
    t.float "elevation", null: false
    t.float "lat", null: false
    t.float "long", null: false
  end

  create_table "groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operations", primary_key: "op_uid", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid "client_uid", null: false
    t.string "op_name", limit: 100, null: false
    t.float "lat", null: false
    t.float "long", null: false

    t.unique_constraint ["op_name"], name: "operations_op_name_key"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username", limit: 20, null: false
    t.string "password_digest", null: false
    t.string "first_name", limit: 30, null: false
    t.string "last_name", limit: 20, null: false
    t.string "email", limit: 345, null: false
    t.string "phone", limit: 20
    t.text "note"
    t.boolean "admin", default: false, null: false
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "contacts", "clients", column: "client_uid", primary_key: "client_uid", name: "contacts_client_uid_fkey"
  add_foreign_key "control_points", "operations", column: "op_uid", primary_key: "op_uid", name: "control_points_op_uid_fkey"
  add_foreign_key "operations", "clients", column: "client_uid", primary_key: "client_uid", name: "operations_client_uid_fkey"
end
