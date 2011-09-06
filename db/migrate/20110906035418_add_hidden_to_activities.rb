class AddHiddenToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :hidden, :boolean
  end

  def self.down
    remove_column :activities, :hidden
  end
end
