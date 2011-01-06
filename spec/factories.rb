Factory.define :artist do |a|
  a.name 'Jungle Boy'
end

Factory.define :another_artist, :class => 'Artist' do |a|
  a.name 'Dan'
end
  
Factory.define :pokemon do |p|
  p.name 'Aerodactyl'
  p.dex_number 142
end
  
Factory.define :form_pokemon, :class => 'Pokemon' do |p|
  p.name 'Genosect'
  p.dex_number 649
  p.form_name { Factory.next(:pokemon_form) }
end

Factory.define :sprite_series do |s|
  s.association :pokemon
end

Factory.define :finished_series, :class => 'SpriteSeries' do |s|
  s.association :pokemon, :factory => :form_pokemon
  s.state :done
end

Factory.define :sprite do |s|
  s.association :series, :factory => :sprite_series
  s.association :artist
  s.step :work
end

Factory.define :contributor do |c|
  c.association :artist
  c.association :series, :factory => :finished_series
  c.role :artist
end

# Sequences
Factory.sequence :pokemon_form do |n|
  "form_#{n}"
end