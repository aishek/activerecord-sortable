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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140721161122) do

  create_table "children", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "parent_id",  :null => false
    t.integer  "position",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "children", ["position"], :name => "index_children_on_position"

  create_table "items", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "position",   :null => false
  end

  add_index "items", ["position"], :name => "index_items_on_position"

  create_table "other_things", :force => true do |t|
    t.integer  "place",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "other_things", ["place"], :name => "index_other_things_on_place"

  create_table "parents", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "things", :force => true do |t|
    t.integer  "position",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "things", ["position"], :name => "index_things_on_position"

end
