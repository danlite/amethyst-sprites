class PokemonController < ApplicationController
  def index
    @pokemon = Pokemon.all#includes(:current_series)
  end

end
