require 'csv'
require 'open-uri'

csv_filename = File.dirname(__FILE__) + "/art.csv"

CSV.foreach(csv_filename, :headers => true) do |row|
  status = row['status']
  next unless status == 'done'
  
  name, form = row['name'], row['form']
  
  pokemon = Pokemon.find_by_name_and_form_name(name, form)
  
  next if pokemon.current_series
  
  series = SpriteSeries.create(:pokemon => pokemon)
  sprite = Sprite.new(:series => series, :step => SPRITE_QC)
  
  puts "Downloading sprite for #{pokemon.full_name}..."
  sprite.image = open(row['url'])
  
  sprite.save!
end