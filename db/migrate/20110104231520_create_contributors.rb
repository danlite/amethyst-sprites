class CreateContributors < ActiveRecord::Migration
  def self.up
    create_table :contributors do |t|
      t.integer :artist_id
      t.string :role
      t.integer :series_id

      t.timestamps
    end
  end

  def self.down
    drop_table :contributors
  end
end
