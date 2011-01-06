class CreateSprites < ActiveRecord::Migration
  def self.up
    create_table :sprites do |t|
      t.integer :series_id
      t.integer :artist_id
      t.string :step

      t.timestamps
    end
  end

  def self.down
    drop_table :sprites
  end
end
