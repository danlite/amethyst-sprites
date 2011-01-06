# Import Pokémon list
file = File.open(Rails.root.join("db", "csv", "pokemon.csv")) do |f|
  f.each_line do |l|
    l.strip!
    next if l.blank?
    
    fields = l.split(',')
    
    form_name = fields[2]
    
    Pokemon.create(
      :dex_number => fields[0],
      :name => fields[1],
      :form_name => form_name.blank? ? nil : form_name
    )
  end
end