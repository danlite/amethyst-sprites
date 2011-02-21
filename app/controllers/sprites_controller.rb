class SpritesController < ApplicationController
  before_filter :authenticate_artist!
  
  def submit
    @series = SpriteSeries.find(params[:series_id])
    if @series.owned? and @series.reserver == current_artist
      
      step = case @series.state
        when SERIES_WORKING, SERIES_RESERVED then SPRITE_WORK
        when SERIES_EDITING then SPRITE_EDIT
        when SERIES_QC then SPRITE_QC
      end
      sprite = Sprite.new(:artist => current_artist, :step => step, :series => @series)
      
      if sprite
        sprite.image = params[:image]
        if sprite.save
          @series.begin_work! if @series.state == SERIES_RESERVED
          expire_fragment(@series.pokemon)
        end
      end
    end
    
    redirect_to series_path(@series)
  end
  
end
