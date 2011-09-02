class AddFormOrderToPokemon < ActiveRecord::Migration
  def self.up
    add_column :pokemon, :form_order, :integer
    
    Pokemon.all.each do |pokemon|
      pokemon.form_order = 0
      pokemon.save
    end
  end

  def self.down
    remove_column :pokemon, :form_order
  end
end
