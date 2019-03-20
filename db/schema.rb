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

ActiveRecord::Schema.define(version: 20190320124643) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "specifications"
  end

  create_table "cable_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "component_equipment_customers", force: :cascade do |t|
    t.bigint "component_id"
    t.bigint "equipment_customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["component_id"], name: "index_component_equipment_customers_on_component_id"
    t.index ["equipment_customer_id"], name: "index_component_equipment_customers_on_equipment_customer_id"
  end

  create_table "components", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipment_customers", force: :cascade do |t|
    t.bigint "equipment_id"
    t.bigint "brand_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "service_id"
    t.bigint "equipment_model_id"
    t.bigint "cable_type_id"
    t.bigint "payment_id"
    t.index ["brand_id"], name: "index_equipment_customers_on_brand_id"
    t.index ["cable_type_id"], name: "index_equipment_customers_on_cable_type_id"
    t.index ["equipment_id"], name: "index_equipment_customers_on_equipment_id"
    t.index ["equipment_model_id"], name: "index_equipment_customers_on_equipment_model_id"
    t.index ["payment_id"], name: "index_equipment_customers_on_payment_id"
    t.index ["service_id"], name: "index_equipment_customers_on_service_id"
  end

  create_table "equipment_models", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipment_modes", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "specifications"
  end

  create_table "generic_prices", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "incomes", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "service_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_incomes_on_client_id"
    t.index ["service_id"], name: "index_incomes_on_service_id"
    t.index ["user_id"], name: "index_incomes_on_user_id"
  end

  create_table "message_histories", force: :cascade do |t|
    t.text "message"
    t.bigint "equipment_customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["equipment_customer_id"], name: "index_message_histories_on_equipment_customer_id"
    t.index ["user_id"], name: "index_message_histories_on_user_id"
  end

  create_table "payment_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "payment_type_id"
    t.decimal "worforce", precision: 10, scale: 2, default: "0.0"
    t.decimal "discount", precision: 10, scale: 2, default: "0.0"
    t.string "departure_date"
    t.bigint "user_id"
    t.bigint "generic_price_id"
    t.decimal "paid_with", precision: 10, scale: 2, default: "0.0"
    t.decimal "change", precision: 10, scale: 2, default: "0.0"
    t.integer "ticket", default: 0
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "paid", default: false
    t.index ["generic_price_id"], name: "index_payments_on_generic_price_id"
    t.index ["payment_type_id"], name: "index_payments_on_payment_type_id"
    t.index ["service_id"], name: "index_payments_on_service_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.integer "quantity"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
  end

  create_table "sale_products", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.integer "quantity"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.bigint "product_id"
    t.bigint "user_id"
    t.bigint "sale_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sale_products_on_product_id"
    t.index ["sale_id"], name: "index_sale_products_on_sale_id"
    t.index ["user_id"], name: "index_sale_products_on_user_id"
  end

  create_table "sales", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0"
    t.decimal "discount", precision: 10, scale: 2, default: "0.0"
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.decimal "paid_with", precision: 10, scale: 2, default: "0.0"
    t.decimal "change", precision: 10, scale: 2, default: "0.0"
    t.integer "ticket", default: 0
    t.bigint "payment_type_id"
    t.index ["payment_type_id"], name: "index_sales_on_payment_type_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "service_spare_parts", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2
    t.integer "quantity"
    t.bigint "service_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "spare_part_id"
    t.integer "control_number", default: 0
    t.bigint "payment_id"
    t.index ["payment_id"], name: "index_service_spare_parts_on_payment_id"
    t.index ["service_id"], name: "index_service_spare_parts_on_service_id"
    t.index ["spare_part_id"], name: "index_service_spare_parts_on_spare_part_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "payment_type_id"
    t.decimal "worforce", precision: 10, scale: 2, default: "0.0"
    t.decimal "discount", precision: 10, scale: 2, default: "0.0"
    t.string "departure_date"
    t.string "image_client"
    t.boolean "paid", default: false
    t.bigint "employee_id"
    t.bigint "generic_price_id"
    t.integer "number_folio"
    t.decimal "paid_with", precision: 10, scale: 2, default: "0.0"
    t.decimal "change", precision: 10, scale: 2, default: "0.0"
    t.integer "total_tickets", default: 0
    t.index ["client_id"], name: "index_services_on_client_id"
    t.index ["employee_id"], name: "index_services_on_employee_id"
    t.index ["generic_price_id"], name: "index_services_on_generic_price_id"
    t.index ["payment_type_id"], name: "index_services_on_payment_type_id"
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "spare_parts", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2
    t.integer "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "control_number", default: 0
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

  add_foreign_key "component_equipment_customers", "components"
  add_foreign_key "component_equipment_customers", "equipment_customers"
  add_foreign_key "equipment_customers", "brands"
  add_foreign_key "equipment_customers", "cable_types"
  add_foreign_key "equipment_customers", "equipment_models"
  add_foreign_key "equipment_customers", "equipments"
  add_foreign_key "equipment_customers", "payments"
  add_foreign_key "equipment_customers", "services"
  add_foreign_key "incomes", "clients"
  add_foreign_key "incomes", "services"
  add_foreign_key "incomes", "users"
  add_foreign_key "message_histories", "equipment_customers"
  add_foreign_key "message_histories", "users"
  add_foreign_key "payments", "generic_prices"
  add_foreign_key "payments", "payment_types"
  add_foreign_key "payments", "services"
  add_foreign_key "payments", "users"
  add_foreign_key "sale_products", "products"
  add_foreign_key "sale_products", "sales"
  add_foreign_key "sale_products", "users"
  add_foreign_key "sales", "payment_types"
  add_foreign_key "sales", "users"
  add_foreign_key "service_spare_parts", "payments"
  add_foreign_key "service_spare_parts", "services"
  add_foreign_key "service_spare_parts", "spare_parts"
  add_foreign_key "services", "clients"
  add_foreign_key "services", "generic_prices"
  add_foreign_key "services", "payment_types"
  add_foreign_key "services", "users"
  add_foreign_key "services", "users", column: "employee_id"
end
