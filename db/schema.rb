# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140717191317) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "order_details", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_option_id"
    t.float    "price"
    t.integer  "quantity"
    t.string   "order_id"
  end

  create_table "orders", id: false, force: true do |t|
    t.string   "token"
    t.string   "transaction_id"
    t.string   "address_one"
    t.string   "address_two"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "status"
    t.string   "number"
    t.string   "uuid"
    t.integer  "user_id"
    t.decimal  "price"
    t.decimal  "shipping"
    t.string   "tracking_number"
    t.string   "phone"
    t.string   "name"
    t.date     "expiration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_option_id"
    t.string   "stripe_charge_id"
    t.string   "stripe_customer_id"
    t.integer  "card_last_4_digit"
    t.string   "card_brand"
    t.integer  "card_exp_month"
    t.integer  "card_exp_year"
    t.boolean  "is_refunded"
    t.float    "refund_amount"
    t.boolean  "is_paid"
    t.string   "email"
    t.string   "billing_full_name"
    t.string   "billing_email"
    t.string   "billing_address1"
    t.string   "billing_address2"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_zip"
    t.string   "billing_country"
  end

  create_table "payment_options", force: true do |t|
    t.decimal  "amount"
    t.string   "amount_display"
    t.text     "description"
    t.string   "shipping_desc"
    t.string   "delivery_desc"
    t.integer  "limit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.boolean  "is_published"
  end

  create_table "transactions", force: true do |t|
    t.string   "order_id"
    t.float    "order_total"
    t.string   "stripe_charge_id"
    t.string   "stripe_customer_id"
    t.string   "card_last_4_digit"
    t.string   "card_brand"
    t.string   "card_exp_month"
    t.string   "card_exp_year"
    t.boolean  "is_refunded"
    t.float    "refund_amount"
    t.boolean  "is_paid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "stripe_charge"
    t.string   "status"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
