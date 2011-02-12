class AddReserverToSpriteSeries < ActiveRecord::Migration
  def self.up
    add_column :sprite_series, :reserver_id, :integer
    add_index :sprite_series, :reserver_id
  end

  def self.down
    remove_column :sprite_series, :reserver_id
  end
end
