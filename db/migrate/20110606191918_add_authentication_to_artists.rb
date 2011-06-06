class AddAuthenticationToArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :email, :string
    add_column :artists, :password_hash, :string
    add_column :artists, :password_salt, :string
  end

  def self.down
    remove_column :artists, :password_salt
    remove_column :artists, :password_hash
    remove_column :artists, :email
  end
end
