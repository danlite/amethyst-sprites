class AddLimboToSpriteSeries < ActiveRecord::Migration
  def self.up
    add_column :sprite_series, :limbo, :boolean
  end

  def self.down
    remove_column :sprite_series, :limbo
  end
end
