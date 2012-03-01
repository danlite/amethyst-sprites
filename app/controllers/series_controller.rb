class SeriesController < ApplicationController
  before_filter :authenticate_artist, :except => [:index, :show, :progress]
  
  def index
    redirect_to root_path unless (params[:pokemon_id] or params[:filter])
    
    if params[:pokemon_id]
      @pokemon = Pokemon.find(params[:pokemon_id])
      @series = @pokemon.series.order("created_at DESC")
    else
      @filter = params[:filter]
      if @filter == 'flagged'
        @series = SpriteSeries.where(:flag => [FLAG_TWEAK, FLAG_REDO]).order("created_at DESC")
      else
        @series = SpriteSeries.where("state = ?", @filter).order("created_at DESC")
      end
    end
  end
  
  def show    
    begin
      @series = SpriteSeries.find(params[:id])
    rescue
      redirect_to :root, :flash => {:errors => "That sprite no longer seems to exist!"}
    end
  end
  
  def destroy
    @series = SpriteSeries.destroy(params[:id])
    
    raise "Not allowed!" unless current_artist and current_artist.admin and @series.state == SERIES_ARCHIVED
    
    pokemon = @series.pokemon
    
    @series.destroy
    
    redirect_to pokemon_path(pokemon)
  end
  
  def transition
    @series = SpriteSeries.find(params[:id])
    possible_events = @series.events_for_artist(current_artist)
    
    raise "No can do" unless possible_events.include?(params[:event].to_sym)
    
    method = (params[:event] + "!").to_sym
    
    raise "Unable to transition" unless @series.send(method)
    @series.reserver = current_artist if @series.in_ownable_state?
    if @series.save
      ProgressActivity.create(:series => @series, :actor => current_artist, :subtype => @series.state, :hidden => [SERIES_AWAITING_APPROVAL, SERIES_ARCHIVED].include?(@series.state))
    end
    
    expire_fragment(@series.pokemon)
    
    redirect_to series_path(@series)
  end
  
  def editor
    @series = SpriteSeries.find(params[:id])
    @editor = true
    @image_data_path = base64_sprite_path(@series.latest_sprite) if @series.latest_sprite
    @submit_image_path = submit_series_sprites_path(@series)
    
    render 'editor/editor'
  end
  
  def change_flag
    series = SpriteSeries.find(params[:id])
    success = series and request.get?
    
    if current_artist.admin and series
      flag = (series.flag.to_i + 1) % 3
      if request.post?
        series.flag = flag
      elsif request.delete?
        series.flag = FLAG_NONE
      end
      
      success = series.save || success
    end
    
    if success
      text = series.flag
      render :text => text
    else
      render :status => 500
    end
  end
  
  def flagged
    flagged_series = SpriteSeries.where(:flag => [FLAG_REDO, FLAG_TWEAK])
    
    render :text => Hash[*flagged_series.map{|s| [s.id, s.flag]}.flatten].to_json
  end
  
end
