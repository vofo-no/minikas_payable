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

ActiveRecord::Schema.define(version: 2019_04_02_073553) do

  create_table "dummy_payers", force: :cascade do |t|
    t.integer "amount"
    t.string "message"
    t.string "bank_account"
    t.string "recipient_name"
    t.string "recipient_postal_code"
    t.string "recipient_postal_city"
    t.integer "learning_association_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minikas_payable_batches", force: :cascade do |t|
    t.string "owner_type"
    t.integer "owner_id"
    t.integer "number", default: 0, null: false
    t.boolean "closed", default: false, null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_minikas_payable_batches_on_owner_type_and_owner_id"
  end

  create_table "minikas_payable_transfers", force: :cascade do |t|
    t.integer "minikas_payable_batch_id"
    t.string "payable_type"
    t.integer "payable_id"
    t.integer "amount", default: 0, null: false
    t.string "message", null: false
    t.string "bank_account", null: false
    t.string "recipient_name", null: false
    t.string "recipient_postal_code", null: false
    t.string "recipient_postal_city", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amount"], name: "index_minikas_payable_transfers_on_amount"
    t.index ["bank_account"], name: "index_minikas_payable_transfers_on_bank_account"
    t.index ["minikas_payable_batch_id"], name: "index_minikas_payable_transfers_on_minikas_payable_batch_id"
    t.index ["payable_type", "payable_id"], name: "index_minikas_payable_transfers_on_payable_type_and_payable_id"
  end

end
