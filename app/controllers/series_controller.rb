class SeriesController < ApplicationController
  before_filter :authenticate_artist, :except => [:index, :show]
  
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
    if @series.save and ![SERIES_AWAITING_APPROVAL, SERIES_ARCHIVED].include?(@series.state)
      ProgressActivity.create(:series => @series, :actor => current_artist, :subtype => @series.state)
    end
    
    expire_fragment(@series.pokemon)
    
    redirect_to series_path(@series)
  end
  
end
