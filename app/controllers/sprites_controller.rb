class SpritesController < ApplicationController
  before_filter :authenticate_artist!
  
  def submit
    @series = SpriteSeries.find(params[:series_id])
    if @series.owned? and @series.current_owner == current_artist
      sprite = nil
      
      if @series.state == SERIES_RESERVED
        sprite = @series.empty_sprite
      else
        step = case @series.state
          when SERIES_WORKING then SPRITE_WORK
          when SERIES_EDITING then SPRITE_EDIT
          when SERIES_QC then SPRITE_QC
        end
        sprite = Sprite.new(:artist => current_artist, :step => step, :series => @series)
      end
      
      if sprite
        sprite.image = params[:image]
        if sprite.save
          case @series.state
            when SERIES_RESERVED then @series.begin_work!
          end
        end
      end
    end
    
    redirect_to series_path(@series)
  end
  
end
