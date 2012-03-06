class AddActedOnAtToPokemon < ActiveRecord::Migration
  def up
    add_column :pokemon, :acted_on_at, :timestamp
    
    Pokemon.reset_column_information
    
    Pokemon.includes(:current_series).each do |p|
      p.acted_on_at = p.current_series ? p.current_series.updated_at : p.created_at
      p.save
    end
  end
  
  def down
    remove_column :pokemon, :acted_on_at
  end
end
