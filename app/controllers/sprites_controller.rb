class SpritesController < ApplicationController
  before_filter :authenticate_artist
  
  def submit
    @series = SpriteSeries.find(params[:series_id])
    
    error_messages = nil
    error_colours = nil
    
    if @series.owned? and @series.reserver == current_artist
      
      step = case @series.state
        when SERIES_WORKING, SERIES_RESERVED then SPRITE_WORK
        when SERIES_EDITING then SPRITE_EDIT
        when SERIES_QC then SPRITE_QC
      end
      sprite = Sprite.new(:artist => current_artist, :step => step, :series => @series, :make_transparent => params[:make_transparent])
      
      if sprite
        sprite.image = params[:image]
        if sprite.save
          @series.begin_work! if @series.state == SERIES_RESERVED
          expire_fragment(@series.pokemon)
          UploadActivity.create(:sprite => sprite, :series => @series)
        else
          error_messages = sprite.errors.full_messages
        end
      end
    end
    
    if sprite.error_num_colours
      error_colours = {:colour_map => sprite.colour_map, :num_colours => sprite.error_num_colours}
      sprite.error_num_colours = nil
    end
    
    redirect_to series_path(@series), :flash => {:errors => error_messages, :error_colours => error_colours}
  end
  
end
