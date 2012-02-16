class SpritesController < ApplicationController
  before_filter :authenticate_artist
  
  def submit
    @series = SpriteSeries.find(params[:series_id])
    
    error_messages = nil
    error_colours = nil
    authorized = true
    sprite_saved = false
    
    if @series.artist_can_upload?(current_artist)
      step = case @series.state
        when SERIES_WORKING, SERIES_RESERVED then SPRITE_WORK
        when SERIES_EDITING then SPRITE_EDIT
        when SERIES_QC then SPRITE_QC
        when SERIES_DONE then SPRITE_REVAMP
      end
      sprite = Sprite.new(:artist => current_artist, :step => step, :series => @series, :make_transparent => params[:make_transparent])
      
      if sprite
        if params[:image]
          sprite.image = params[:image]
        elsif params[:image_data]
          temp = Tempfile.new('imgdata')
          temp.binmode
          temp.write ActiveSupport::Base64.decode64(params[:image_data])
          sprite.image = temp
        end
        
        sprite_saved = sprite.save
        
        if sprite_saved
          @series.begin_work! if @series.state == SERIES_RESERVED
          expire_fragment(@series.pokemon)
          UploadActivity.create(:sprite => sprite, :series => @series)
        else
          error_messages = sprite.errors.full_messages
        end
      end

      if sprite.error_num_colours
        error_colours = {:colour_map => sprite.colour_map, :num_colours => sprite.error_num_colours}
        sprite.error_num_colours = nil
      end
    else
      authorized = false
      error_messages = 'You are not the owner of this Pokemon sprite.'
    end
    
    if request.xhr?
      status = sprite_saved ? 200 : (authorized ? 400 : 403)
      render :text => (status == 200) ? series_path(@series) : '', :status => status 
    else
      redirect_to series_path(@series), :flash => {:errors => error_messages, :error_colours => error_colours}
    end
  end
  
  def base64
    @sprite = Sprite.find(params[:id])
    
    if @sprite.image.file?
      render :text => ActiveSupport::Base64.encode64(@sprite.image.to_file.read).gsub("\n", '')
    else
      render :status => 404
    end
  end
  
end
