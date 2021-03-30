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

ActiveRecord::Schema.define(version: 2021_03_30_193925) do

  create_table "email_records", force: :cascade do |t|
    t.datetime "sent"
    t.string "subject"
    t.string "to"
    t.integer "shop_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shop_id"], name: "index_email_records_on_shop_id"
  end

  create_table "nonces", force: :cascade do |t|
    t.string "nonce"
    t.string "shop_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_complete"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.integer "cost_monthly"
    t.integer "trial_days"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "display_name"
    t.text "description"
    t.integer "free_email_limit"
    t.boolean "default_plan"
    t.integer "capped_amount"
  end

  create_table "shops", force: :cascade do |t|
    t.string "token"
    t.string "shop_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "plan_id"
    t.string "plan_name"
    t.string "shopify_subs_id"
    t.index ["plan_id"], name: "index_shops_on_plan_id"
  end

  add_foreign_key "email_records", "shops"
  add_foreign_key "shops", "plans"
end
