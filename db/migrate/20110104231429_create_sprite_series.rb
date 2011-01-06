class CreateSpriteSeries < ActiveRecord::Migration
  def self.up
    create_table :sprite_series do |t|
      t.integer :pokemon_id
      t.string :state

      t.timestamps
    end
  end

  def self.down
    drop_table :sprite_series
  end
end
