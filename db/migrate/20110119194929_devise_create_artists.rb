class DeviseCreateArtists < ActiveRecord::Migration
  def self.up
    change_table(:artists) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
    end

    add_index :artists, :email,                :unique => true
    add_index :artists, :reset_password_token, :unique => true
  end

  def self.down
    change_table(:artists) do |t|
      remove_column :artists, :email
      remove_column :artists, :encrypted_password
      remove_column :artists, :password_salt
      remove_column :artists, :reset_password_token
      remove_column :artists, :remember_token
      remove_column :artists, :remember_created_at
      remove_column :artists, :sign_in_count
      remove_column :artists, :current_sign_in_at
      remove_column :artists, :last_sign_in_at
      remove_column :artists, :current_sign_in_ip
      remove_column :artists, :last_sign_in_ip
    end
  end
end
