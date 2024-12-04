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

ActiveRecord::Schema[8.0].define(version: 2024_12_04_092847) do
  create_table "products", primary_key: "product_id", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.decimal "price", precision: 10
    t.text "description"
    t.string "category"
    t.string "image"
    t.float "rating_rate"
    t.integer "rating_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", primary_key: "transaction_id", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "source_wallet_number"
    t.bigint "target_wallet_number"
    t.bigint "product_id"
    t.decimal "amount", precision: 10
    t.string "transaction_type"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_transactions_on_product_id"
    t.index ["source_wallet_number"], name: "index_transactions_on_source_wallet_number"
    t.index ["target_wallet_number"], name: "index_transactions_on_target_wallet_number"
  end

  create_table "users", primary_key: "user_id", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password", limit: 100
    t.string "password_digest"
    t.index ["email"], name: "unique_emails", unique: true
  end

  create_table "wallets", primary_key: "wallet_id", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "wallet_number"
    t.decimal "balance", precision: 10
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "transactions", "products", primary_key: "product_id"
  add_foreign_key "transactions", "wallets", column: "source_wallet_number", primary_key: "wallet_id"
  add_foreign_key "transactions", "wallets", column: "target_wallet_number", primary_key: "wallet_id"
  add_foreign_key "wallets", "users", primary_key: "user_id"
end
