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

ActiveRecord::Schema.define(version: 2023_04_11_105501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer "member_id"
    t.integer "total_savings"
  end

  create_table "loans", force: :cascade do |t|
    t.float "amount"
    t.float "integer"
    t.float "balance"
    t.datetime "due_date"
    t.integer "type_of_loan"
    t.integer "account_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "member_id"
    t.string "member_status"
    t.integer "user_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "staff_id"
    t.string "role"
    t.integer "user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.float "amount"
    t.string "trx_ref"
    t.text "narative"
    t.integer "account_id"
    t.string "txn_response"
    t.string "txn_type"
    t.string "txn_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "password"
    t.string "avatar"
  end

end
