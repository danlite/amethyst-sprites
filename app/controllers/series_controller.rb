class SeriesController < ApplicationController
  before_filter :authenticate_artist!, :except => [:show]
  
  def show
    @series = SpriteSeries.find(params[:id])
  end
  
  def transition
    @series = SpriteSeries.find(params[:id])
    possible_events = @series.events_for_artist(current_artist)
    
    raise "No can do" unless possible_events.include?(params[:event].to_sym)
    
    method = (params[:event] + "!").to_sym
    
    raise "Unable to transition" unless @series.send(method)
    @series.reserver = current_artist if @series.owned?
    @series.save
    
    redirect_to series_path(@series)
  end
  
end
