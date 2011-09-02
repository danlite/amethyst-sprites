require 'csv'
require 'open-uri'

csv_filename = File.dirname(__FILE__) + "/art.csv"

CSV.foreach(csv_filename, :headers => true) do |row|
  status = row['status']
  next if status.blank? or status == 'reserved'
  
  name, form = row['name'], row['form']
  
  pokemon = Pokemon.find_by_name_and_form_name(name, form)
  
  next if pokemon.current_series
  
  series_state = SERIES_AWAITING_QC
  sprite_step = SPRITE_EDIT
  
  if status == 'done'
    series_state = SERIES_DONE
    sprite_step = SPRITE_QC
  end
  
  series = SpriteSeries.new(:pokemon => pokemon, :state => series_state, :limbo => status == 'limbo')
  
  artist_names = row['artists'].split("|")
  artist_names.each do |artist_name|
    real_artist = Artist.find_by_name(artist_name)
    contributor = Contributor.new(:series => series)
    if real_artist
      contributor.artist = real_artist
      puts "Existing user '#{artist_name}'"
    else
      contributor.name = artist_name
      puts "Couldn't find '#{artist_name}'"
    end
    contributor.save!
  end
  
  sprite = Sprite.new(:series => series, :step => sprite_step)
  
  puts "Downloading sprite for #{pokemon.full_name}..."
  sprite.image = open(row['url'])
  
  series.save
  sprite.save!
end