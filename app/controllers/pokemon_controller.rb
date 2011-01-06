class PokemonController < ApplicationController
  def index
    @pokemon = Pokemon.all
    @series = Hash[*SpriteSeries.where('pokemon_id IN (?) AND state != ?', @pokemon, :archived).collect{|s| [s.pokemon_id, s]}.flatten]
  end

end
