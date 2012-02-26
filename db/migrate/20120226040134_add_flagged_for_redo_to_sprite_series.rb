class AddFlaggedForRedoToSpriteSeries < ActiveRecord::Migration
  def change
    add_column :sprite_series, :flagged_for_redo, :boolean
    unknown_arceus = Pokemon.find_by_name_and_form_name('Arceus', '???')
    unknown_arceus.destroy if unknown_arceus
  end
end
