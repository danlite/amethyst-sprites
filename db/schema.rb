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

ActiveRecord::Schema.define(:version => 20120716022647) do

  create_table "activities", :force => true do |t|
    t.string   "type"
    t.string   "subtype"
    t.integer  "actor_id"
    t.integer  "series_id"
    t.integer  "sprite_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hidden"
    t.integer  "comment_id"
  end

  add_index "activities", ["actor_id"], :name => "index_activities_on_actor_id"
  add_index "activities", ["series_id"], :name => "index_activities_on_series_id"
  add_index "activities", ["subtype"], :name => "index_activities_on_subtype"
  add_index "activities", ["type"], :name => "index_activities_on_type"

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.boolean  "qc"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "artist_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"

  create_table "contributors", :force => true do |t|
    t.integer  "artist_id"
    t.string   "role"
    t.integer  "series_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "pokemon", :force => true do |t|
    t.string   "name"
    t.string   "form_name"
    t.integer  "dex_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_series_id"
    t.integer  "form_order"
    t.datetime "acted_on_at"
  end

  add_index "pokemon", ["current_series_id"], :name => "index_pokemon_on_current_series_id"
  add_index "pokemon", ["name", "form_name"], :name => "index_pokemon_on_name_and_form_name", :unique => true

  create_table "sprite_series", :force => true do |t|
    t.integer  "pokemon_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reserver_id"
    t.boolean  "limbo"
    t.integer  "flag"
  end

  add_index "sprite_series", ["pokemon_id"], :name => "index_sprite_series_on_pokemon_id"
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
    t.text     "colour_map"
  end

  add_index "sprites", ["series_id"], :name => "index_sprites_on_series_id"

end
