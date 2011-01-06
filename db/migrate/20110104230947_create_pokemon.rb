class CreatePokemon < ActiveRecord::Migration
  def self.up
    create_table :pokemon do |t|
      t.string :name
      t.string :form_name
      t.integer :dex_number

      t.timestamps
    end
  end

  def self.down
    drop_table :pokemon
  end
end
