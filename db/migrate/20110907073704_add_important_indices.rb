class AddImportantIndices < ActiveRecord::Migration
  def self.up
    remove_column :activities, :pokemon_id
    
    add_index :activities, :type
    add_index :activities, :subtype
    add_index :activities, :actor_id
    add_index :activities, :series_id
    
    add_index :comments, :commentable_id
    add_index :pokemon, :current_series_id
    add_index :sprite_series, :pokemon_id
    add_index :sprites, :series_id
    
    drop_table :reservations
  end

  def self.down
    create_table "reservations", :force => true do |t|
      t.integer  "artist_id"
      t.integer  "series_id"
      t.string   "step"
      t.boolean  "active"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    remove_index :sprites, :series_id
    remove_index :sprite_series, :pokemon_id
    remove_index :pokemon, :current_series_id
    remove_index :comments, :commentable_id
    
    remove_index :activities, :series_id
    remove_index :activities, :actor_id
    remove_index :activities, :subtype
    remove_index :activities, :type
    
    add_column :activities, :pokemon_id, :integer
  end
end
