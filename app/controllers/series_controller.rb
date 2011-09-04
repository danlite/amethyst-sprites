class SeriesController < ApplicationController
  before_filter :authenticate_artist, :except => [:show]
  
  def index
    redirect_to root_path unless params[:pokemon_id]
    
    @pokemon = Pokemon.find(params[:pokemon_id])
    
    @series = @pokemon.series.order("created_at DESC")
  end
  
  def show
    @series = SpriteSeries.find(params[:id])
  end
  
  def transition
    @series = SpriteSeries.find(params[:id])
    possible_events = @series.events_for_artist(current_artist)
    
    raise "No can do" unless possible_events.include?(params[:event].to_sym)
    
    method = (params[:event] + "!").to_sym
    
    raise "Unable to transition" unless @series.send(method)
    @series.reserver = current_artist if @series.in_ownable_state?
    @series.save
    
    expire_fragment(@series.pokemon)
    
    redirect_to series_path(@series)
  end
  
end
