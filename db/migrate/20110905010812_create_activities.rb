class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :type
      t.string :subtype
      t.integer :actor_id
      t.integer :pokemon_id
      t.integer :series_id
      t.integer :sprite_id

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
