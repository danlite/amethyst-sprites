class PokemonController < ApplicationController
  before_filter :authenticate_artist, :except => [:index, :show]
  
  def index
    @pokemon = Pokemon.includes(:current_series).order('dex_number ASC, form_order ASC, form_name ASC')
  end
  
  def show
    name, form = params[:name], params[:form]
    
    if form and name
      @pokemon = Pokemon.find_by_name_and_form_name(name, form)
    elsif name
      @pokemon = Pokemon.find_by_name(name)
    else
      @pokemon = Pokemon.find(params[:id])
    end
    
    @current_series = @pokemon.current_series
  end
  
  def claim
    @pokemon = Pokemon.find(params[:id])
    @series = current_artist.claim_pokemon(@pokemon)
    expire_fragment(@pokemon)
    redirect_to named_pokemon_path(@pokemon.name, @pokemon.form_name)
  end
  
  def unclaim
    @pokemon = Pokemon.find(params[:id])
    @series = @pokemon.current_series
    if @series and @series.state == SERIES_RESERVED and @series.reserver == current_artist
      @series.destroy
      expire_fragment(@pokemon)
    end
    redirect_to pokemon_index_path
  end
  
end
