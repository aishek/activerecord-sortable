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

ActiveRecord::Schema.define(version: 20150408101403) do

  create_table "children", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "parent_id",  null: false
    t.integer  "position",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "children", ["position"], name: "index_children_on_position"

  create_table "items", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   null: false
  end

  add_index "items", ["position"], name: "index_items_on_position"

  create_table "order_things", force: :cascade do |t|
    t.integer  "order",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "order_things", ["order"], name: "index_order_things_on_order"

  create_table "other_things", force: :cascade do |t|
    t.integer  "place",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "other_things", ["place"], name: "index_other_things_on_place"

  create_table "parents", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "things", force: :cascade do |t|
    t.integer  "position",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "things", ["position"], name: "index_things_on_position"

end
