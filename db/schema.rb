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

ActiveRecord::Schema.define(:version => 20110606191918) do

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.boolean  "qc"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
  end

  create_table "contributors", :force => true do |t|
    t.integer  "artist_id"
    t.string   "role"
    t.integer  "series_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pokemon", :force => true do |t|
    t.string   "name"
    t.string   "form_name"
    t.integer  "dex_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_series_id"
  end

  create_table "sprite_series", :force => true do |t|
    t.integer  "pokemon_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reserver_id"
  end

  add_index "sprite_series", ["reserver_id"], :name => "index_sprite_series_on_reserver_id"

  create_table "sprites", :force => true do |t|
    t.integer  "series_id"
    t.integer  "artist_id"
    t.string   "step"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

end
