class AddColourMapToSprite < ActiveRecord::Migration
  def self.up
    add_column :sprites, :colour_map, :text
  end

  def self.down
    remove_column :sprites, :colour_map
  end
end
