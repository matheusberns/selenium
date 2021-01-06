# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_06_024951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "products", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "code", limit: 255, null: false
    t.text "description", null: false
    t.integer "derivation", null: false
    t.float "price", null: false
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.boolean "active", default: true, null: false
    t.datetime "deleted_at"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_products_on_active"
    t.index ["created_by_id"], name: "index_products_on_created_by_id"
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
    t.index ["updated_by_id"], name: "index_products_on_updated_by_id"
    t.index ["uuid"], name: "index_products_on_uuid"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "email", limit: 60
    t.boolean "active", default: true, null: false
    t.text "tokens"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_users_on_active"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, where: "(deleted_at IS NULL)"
  end

  add_foreign_key "products", "users", column: "created_by_id"
  add_foreign_key "products", "users", column: "updated_by_id"
end
