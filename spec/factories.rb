include ActionDispatch::TestProcess

Factory.define :artist do |a|
  a.name 'Jungle Boy'
  a.email 'jungleboy@email.net'
  a.password '123456'
end

Factory.define :another_artist, :class => 'Artist' do |a|
  a.name 'Dan'
  a.email 'dan@email.net'
  a.password 'qwerty'
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
  s.image fixture_file_upload(Rails.root.join('spec/sprite.png'), 'image/png')
  s.association :series, :factory => :sprite_series
  s.association :artist
  s.step SPRITE_WORK
end

Factory.define :contributor do |c|
  c.association :artist
  c.association :series, :factory => :finished_series
  c.name 'Jungle Boy'
end

Factory.define :reservation do |r|
  r.association :artist
  r.association :series, :factory => :sprite_series
  r.step SPRITE_WORK
end

Factory.define :comment do |c|
  c.association :artist, :factory => :another_artist
  c.association :commentable, :factory => :sprite
  c.body "This is a FABulous sprite!!! ^_~"
end

Factory.define :upload_activity do |a|
  a.association :sprite
end

Factory.define :comment_activity do |a|
  a.association :comment
end

# Sequences
Factory.sequence :pokemon_form do |n|
  "form_#{n}"
end