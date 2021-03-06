class PokemonController < ApplicationController
  before_filter :authenticate_artist, :except => [:index, :show]
  
  def index
    @javascripts = 'gallery'
    
    @pokemon = Pokemon.includes(:current_series).order('dex_number ASC, form_order ASC, form_name ASC')
    
    @newest_artists = Artist.order("created_at DESC").all
    @remaining_artists = Artist.count - @newest_artists.count
    
    @recent_changes = Pokemon.recently_changed
  end
  
  def show
    name, form = params[:name], params[:form]
    
    if name
      @pokemon = Pokemon.find_by_name_and_form_name(name, form)
    else
      @pokemon = Pokemon.find(params[:id])
    end
    
    @series = @pokemon.current_series
    
    render 'series/show' if @series
  end
  
  def claim
    @pokemon = Pokemon.find(params[:id])
    @series = current_artist.claim_pokemon(@pokemon)
    
    ProgressActivity.create(:series => @series, :actor => current_artist, :subtype => SERIES_RESERVED)
    
    expire_fragment(@pokemon)
    remaining_reservations = Artist::MAXIMUM_CONCURRENT_WORKS - current_artist.current_wip
    reservation_text = remaining_reservations == 0 ? "You must finish your other sprites before reserving any more Pokemon." : "You may reserve #{remaining_reservations} more Pokemon."
    flash_hash = @series ? {:notice => "Reserved #{@pokemon.full_name}! #{reservation_text}"} : {:flash => {:errors => "Unable to reserve #{@pokemon.full_name}."}}
    redirect_to named_pokemon_path(@pokemon.name, @pokemon.form_name), flash_hash
  end
  
  def unclaim
    @pokemon = Pokemon.find(params[:id])
    @series = @pokemon.current_series
    if @series and @series.state == SERIES_RESERVED and @series.reserver == current_artist
      old_limbo_series = @pokemon.series.where("limbo = ?", true).first
      @pokemon.current_series = old_limbo_series
      @pokemon.save
      @series.destroy
      expire_fragment(@pokemon)
    end
    redirect_to pokemon_index_path
  end
  
end
