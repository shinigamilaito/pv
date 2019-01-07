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

ActiveRecord::Schema.define(version: 20190107214359) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "specifications"
  end

  create_table "client_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "address"
    t.string "mobile_phone"
    t.string "home_phone"
  end

  create_table "equipment_customers", force: :cascade do |t|
    t.bigint "equipment_id"
    t.bigint "brand_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "service_id"
    t.index ["brand_id"], name: "index_equipment_customers_on_brand_id"
    t.index ["equipment_id"], name: "index_equipment_customers_on_equipment_id"
    t.index ["service_id"], name: "index_equipment_customers_on_service_id"
  end

  create_table "equipments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "specifications"
  end

  create_table "payment_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "client_id"
    t.string "folio"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_services_on_client_id"
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "spare_parts", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2
    t.integer "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "support_spare_parts", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2
    t.integer "quantity"
    t.bigint "support_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["support_id"], name: "index_support_spare_parts_on_support_id"
  end

  create_table "supports", force: :cascade do |t|
    t.bigint "equipment_customer_id"
    t.text "description"
    t.string "date_of_entry"
    t.bigint "payment_type_id"
    t.bigint "client_type_id"
    t.decimal "worforce", precision: 10, scale: 2
    t.decimal "discount", precision: 10, scale: 2
    t.string "departure_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_client"
    t.index ["client_type_id"], name: "index_supports_on_client_type_id"
    t.index ["equipment_customer_id"], name: "index_supports_on_equipment_customer_id"
    t.index ["payment_type_id"], name: "index_supports_on_payment_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.bigint "rol_id", null: false
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["rol_id"], name: "index_users_on_rol_id"
  end

  add_foreign_key "equipment_customers", "brands"
  add_foreign_key "equipment_customers", "equipments"
  add_foreign_key "equipment_customers", "services"
  add_foreign_key "services", "clients"
  add_foreign_key "services", "users"
  add_foreign_key "support_spare_parts", "supports"
  add_foreign_key "supports", "client_types"
  add_foreign_key "supports", "equipment_customers"
  add_foreign_key "supports", "payment_types"
end
