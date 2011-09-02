class AddNameToContributor < ActiveRecord::Migration
  def self.up
    add_column :contributors, :name, :string
  end

  def self.down
    remove_column :contributors, :name
  end
end
