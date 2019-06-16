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

ActiveRecord::Schema.define(version: 20190616163411) do

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

  create_table "cash_closing_services_sales", force: :cascade do |t|
    t.string "type_cash", default: "services_sales"
    t.datetime "close_date"
    t.bigint "user_id"
    t.decimal "total_effective", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_debit_card", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_credit_card", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_sales", precision: 10, scale: 2, default: "0.0"
    t.decimal "open_amount", precision: 10, scale: 2, default: "0.0"
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.bigint "cash_opening_services_sale_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cash_opening_services_sale_id"], name: "cash_opening_services_sale"
    t.index ["user_id"], name: "index_cash_closing_services_sales_on_user_id"
  end

  create_table "cash_movements", force: :cascade do |t|
    t.string "cash_type"
    t.bigint "cash_id"
    t.bigint "user_id"
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.string "type_movement"
    t.string "reason"
    t.bigint "payment_type_id"
    t.string "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cash_type", "cash_id"], name: "index_cash_movements_on_cash_type_and_cash_id"
    t.index ["payment_type_id"], name: "index_cash_movements_on_payment_type_id"
    t.index ["user_id"], name: "index_cash_movements_on_user_id"
  end

  create_table "cash_opening_services_sales", force: :cascade do |t|
    t.string "type_cash", default: "services_sales"
    t.datetime "open_date"
    t.bigint "user_id"
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cash_opening_services_sales_on_user_id"
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
    t.string "email"
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
    t.string "serie_number"
    t.text "component_description"
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

  create_table "invitation_printing_products", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "invitation_id"
    t.bigint "printing_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "from_printing_products", default: true
    t.index ["invitation_id"], name: "index_invitation_printing_products_on_invitation_id"
    t.index ["printing_product_id"], name: "index_invitation_printing_products_on_printing_product_id"
    t.index ["user_id"], name: "index_invitation_printing_products_on_user_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "imagen"
    t.boolean "created_in_quotation", default: false
    t.index ["user_id"], name: "index_invitations_on_user_id"
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

  create_table "partial_sales", force: :cascade do |t|
    t.bigint "printing_sale_id"
    t.decimal "payment", precision: 10, scale: 2, default: "0.0"
    t.decimal "difference", precision: 10, scale: 2, default: "0.0"
    t.bigint "payment_type_id"
    t.decimal "change", precision: 10, scale: 2, default: "0.0"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "paid_with", precision: 10, scale: 2, default: "0.0"
    t.index ["payment_type_id"], name: "index_partial_sales_on_payment_type_id"
    t.index ["printing_sale_id"], name: "index_partial_sales_on_printing_sale_id"
    t.index ["user_id"], name: "index_partial_sales_on_user_id"
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
    t.bigint "cash_opening_services_sale_id"
    t.index ["cash_opening_services_sale_id"], name: "index_payments_on_cash_opening_services_sale_id"
    t.index ["generic_price_id"], name: "index_payments_on_generic_price_id"
    t.index ["payment_type_id"], name: "index_payments_on_payment_type_id"
    t.index ["service_id"], name: "index_payments_on_service_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "printing_product_quotations", force: :cascade do |t|
    t.bigint "invitation_printing_product_id"
    t.bigint "quotation_printing_id"
    t.bigint "user_id"
    t.string "code"
    t.string "name"
    t.decimal "quantity", precision: 10, scale: 2, default: "0.0"
    t.decimal "purchase_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "real_price", precision: 20, scale: 10, default: "0.0"
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.string "sale_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invitation_printing_product_id"], name: "invitation_printing_product"
    t.index ["quotation_printing_id"], name: "index_printing_product_quotations_on_quotation_printing_id"
    t.index ["user_id"], name: "index_printing_product_quotations_on_user_id"
  end

  create_table "printing_products", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.decimal "purchase_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "sale_price", precision: 10, scale: 2, default: "0.0"
    t.string "sale_unit"
    t.integer "stock"
    t.integer "contains"
    t.string "contain_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "imagen"
    t.integer "discount_stock", default: 0
  end

  create_table "printing_sale_products", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.integer "quantity"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.bigint "printing_product_id"
    t.bigint "user_id"
    t.bigint "printing_sale_id"
    t.decimal "real_price", precision: 20, scale: 10, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sale_unit"
    t.index ["printing_product_id"], name: "index_printing_sale_products_on_printing_product_id"
    t.index ["printing_sale_id"], name: "index_printing_sale_products_on_printing_sale_id"
    t.index ["user_id"], name: "index_printing_sale_products_on_user_id"
  end

  create_table "printing_sales", force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0"
    t.decimal "discount", precision: 10, scale: 2, default: "0.0"
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.decimal "paid_with", precision: 10, scale: 2, default: "0.0"
    t.decimal "change", precision: 10, scale: 2, default: "0.0"
    t.integer "ticket", default: 0
    t.bigint "payment_type_id"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "total_paid", default: true
    t.decimal "difference", precision: 10, scale: 2, default: "0.0"
    t.boolean "full_payment"
    t.decimal "payment", precision: 10, scale: 2, default: "0.0"
    t.index ["client_id"], name: "index_printing_sales_on_client_id"
    t.index ["payment_type_id"], name: "index_printing_sales_on_payment_type_id"
    t.index ["user_id"], name: "index_printing_sales_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.integer "quantity"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.integer "stock_minimum", default: 0
  end

  create_table "quotation_printings", force: :cascade do |t|
    t.bigint "invitation_id"
    t.bigint "client_id"
    t.decimal "cost_piece", precision: 10, scale: 2, default: "0.0"
    t.integer "total_pieces"
    t.decimal "cost_elaboration", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_quotations", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_cost", precision: 10, scale: 2, default: "0.0"
    t.decimal "utility", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number_folio"
    t.string "status"
    t.decimal "paid_with", precision: 10, scale: 2, default: "0.0"
    t.decimal "payment", precision: 10, scale: 2, default: "0.0"
    t.decimal "change", precision: 10, scale: 2, default: "0.0"
    t.decimal "difference", precision: 10, scale: 2, default: "0.0"
    t.bigint "payment_type_id"
    t.boolean "full_payment"
    t.bigint "user_id"
    t.index ["client_id"], name: "index_quotation_printings_on_client_id"
    t.index ["invitation_id"], name: "index_quotation_printings_on_invitation_id"
    t.index ["payment_type_id"], name: "index_quotation_printings_on_payment_type_id"
    t.index ["user_id"], name: "index_quotation_printings_on_user_id"
  end

  create_table "quotation_products", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.integer "quantity"
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.bigint "product_id"
    t.bigint "user_id"
    t.bigint "quotation_id"
    t.decimal "discount", precision: 10, scale: 2, default: "0.0"
    t.decimal "real_price", precision: 20, scale: 14, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_quotation_products_on_product_id"
    t.index ["quotation_id"], name: "index_quotation_products_on_quotation_id"
    t.index ["user_id"], name: "index_quotation_products_on_user_id"
  end

  create_table "quotations", force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "total", precision: 20, scale: 14, default: "0.0"
    t.integer "folio", default: 0
    t.bigint "client_id"
    t.string "status", default: "Vigente"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_quotations_on_client_id"
    t.index ["user_id"], name: "index_quotations_on_user_id"
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
    t.decimal "discount", precision: 10, scale: 2, default: "0.0"
    t.decimal "real_price", precision: 20, scale: 10, default: "0.0"
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
    t.bigint "cash_opening_services_sale_id"
    t.index ["cash_opening_services_sale_id"], name: "index_sales_on_cash_opening_services_sale_id"
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
    t.string "image_client"
    t.boolean "paid", default: false
    t.integer "number_folio"
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
    t.string "code"
    t.integer "stock_minimum", default: 0
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
    t.text "address"
    t.string "contact"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["rol_id"], name: "index_users_on_rol_id"
  end

  add_foreign_key "cash_closing_services_sales", "cash_opening_services_sales"
  add_foreign_key "cash_closing_services_sales", "users"
  add_foreign_key "cash_movements", "payment_types"
  add_foreign_key "cash_movements", "users"
  add_foreign_key "cash_opening_services_sales", "users"
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
  add_foreign_key "invitation_printing_products", "invitations"
  add_foreign_key "invitation_printing_products", "printing_products"
  add_foreign_key "invitation_printing_products", "users"
  add_foreign_key "invitations", "users"
  add_foreign_key "message_histories", "equipment_customers"
  add_foreign_key "message_histories", "users"
  add_foreign_key "partial_sales", "payment_types"
  add_foreign_key "partial_sales", "printing_sales"
  add_foreign_key "partial_sales", "users"
  add_foreign_key "payments", "cash_opening_services_sales"
  add_foreign_key "payments", "generic_prices"
  add_foreign_key "payments", "payment_types"
  add_foreign_key "payments", "services"
  add_foreign_key "payments", "users"
  add_foreign_key "printing_product_quotations", "invitation_printing_products"
  add_foreign_key "printing_product_quotations", "quotation_printings"
  add_foreign_key "printing_product_quotations", "users"
  add_foreign_key "printing_sale_products", "printing_products"
  add_foreign_key "printing_sale_products", "printing_sales"
  add_foreign_key "printing_sale_products", "users"
  add_foreign_key "printing_sales", "clients"
  add_foreign_key "printing_sales", "payment_types"
  add_foreign_key "printing_sales", "users"
  add_foreign_key "quotation_printings", "clients"
  add_foreign_key "quotation_printings", "invitations"
  add_foreign_key "quotation_printings", "payment_types"
  add_foreign_key "quotation_printings", "users"
  add_foreign_key "quotation_products", "products"
  add_foreign_key "quotation_products", "quotations"
  add_foreign_key "quotation_products", "users"
  add_foreign_key "quotations", "clients"
  add_foreign_key "quotations", "users"
  add_foreign_key "sale_products", "products"
  add_foreign_key "sale_products", "sales"
  add_foreign_key "sale_products", "users"
  add_foreign_key "sales", "cash_opening_services_sales"
  add_foreign_key "sales", "payment_types"
  add_foreign_key "sales", "users"
  add_foreign_key "service_spare_parts", "payments"
  add_foreign_key "service_spare_parts", "services"
  add_foreign_key "service_spare_parts", "spare_parts"
  add_foreign_key "services", "clients"
  add_foreign_key "services", "users"
end
