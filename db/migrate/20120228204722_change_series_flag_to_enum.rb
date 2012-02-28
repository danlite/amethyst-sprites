class ChangeSeriesFlagToEnum < ActiveRecord::Migration
  def up
    add_column :sprite_series, :flag, :integer
    
    SpriteSeries.reset_column_information
    SpriteSeries.update_all({:flag => FLAG_TWEAK}, {:flagged_for_redo => true})
    
    remove_column :sprite_series, :flagged_for_redo
  end
  
  def down
    add_column :sprite_series, :flagged_for_redo, :boolean
    
    SpriteSeries.reset_column_information
    SpriteSeries.update_all({:flagged_for_redo => true}, {:flag => [FLAG_TWEAK, FLAG_REDO]})
    
    remove_column :sprite_series, :flag
  end
end
