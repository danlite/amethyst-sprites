class PokemonController < ApplicationController
  before_filter :authenticate_artist!, :except => [:index, :show]
  
  def index
    @pokemon = Pokemon.includes(:current_series).order('id ASC')
  end
  
  def show
    @pokemon = Pokemon.find(params[:id])
    @current_series = @pokemon.current_series
  end
  
  def claim
    @pokemon = Pokemon.find(params[:id])
    @series = current_artist.claim_pokemon(@pokemon)
    redirect_to @pokemon
  end
  
  def unclaim
    @pokemon = Pokemon.find(params[:id])
    @series = @pokemon.current_series
    if @series and @series.state == SERIES_RESERVED and @series.sprites.first.artist == current_artist
      @series.delete
    end
    redirect_to pokemon_index_path
  end
  
end
