class AddAdminToArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :admin, :boolean
    add_column :artists, :qc, :boolean
  end

  def self.down
    remove_column :artists, :qc
    remove_column :artists, :admin
  end
end
