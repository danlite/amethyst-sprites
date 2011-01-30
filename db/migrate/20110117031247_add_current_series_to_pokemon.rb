class AddCurrentSeriesToPokemon < ActiveRecord::Migration
  def self.up
    add_column :pokemon, :current_series_id, :integer
  end

  def self.down
    remove_column :pokemon, :current_series_id
  end
end
