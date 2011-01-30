class PokemonController < ApplicationController
  before_filter :authenticate_artist!, :except => [:index, :show]
  
  def index
    @pokemon = Pokemon.all#includes(:current_series)
  end
  
  def show
    @pokemon = Pokemon.find(params[:id])
    @current_series = @pokemon.series.current.first
  end
  
  def claim
    @pokemon = Pokemon.find(params[:id])
    @series = current_artist.claim_pokemon(@pokemon)
    redirect_to pokemon_index_path
  end
  
  def unclaim
    @pokemon = Pokemon.find(params[:id])
    @series = @pokemon.series.current.first
    if @series and @series.state == :reserved and @series.sprites.first.artist == current_artist
      @series.delete
    end
    redirect_to pokemon_path(@pokemon)
  end
  
end
