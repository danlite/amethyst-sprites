class SeriesController < ApplicationController
  
  def show
    @series = SpriteSeries.find(params[:id])
  end
  
end
