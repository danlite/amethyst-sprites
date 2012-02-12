class PokemonController < ApplicationController
  before_filter :authenticate_artist, :except => [:index, :show]
  
  def index
    @pokemon = Pokemon.includes(:current_series).order('dex_number ASC, form_order ASC, form_name ASC')
    
    @newest_artists = Artist.order("created_at DESC").all
    @remaining_artists = Artist.count - @newest_artists.count
    
    visible_activities = Activity.visible
    @latest_activities = visible_activities.order("created_at DESC").limit(15).all
    @older_activity_count = visible_activities.count - @latest_activities.count
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
    
    ProgressActivity.create(:series => @series, :actor => current_artist, :subtype => SERIES_RESERVED)
    
    expire_fragment(@pokemon)
    remaining_reservations = Artist::MAXIMUM_CONCURRENT_WORKS - current_artist.current_wip
    reservation_text = remaining_reservations == 0 ? "You must finish your other sprites before reserving any more Pokemon." : "You may reserve #{remaining_reservations} more Pokemon."
    redirect_to named_pokemon_path(@pokemon.name, @pokemon.form_name), :notice => "Reserved #{@pokemon.full_name}! #{reservation_text}"
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
