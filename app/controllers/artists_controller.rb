class ArtistsController < ApplicationController
  before_filter :authenticate_artist, :only => [:work]
  
  def new
    @artist = Artist.new
  end
  
  def create
    @artist = Artist.new(params[:artist])
    if @artist.save
      session[:user_id] = @artist.id
      redirect_to root_url, :notice => "Signed up!"
    else
      render 'new'
    end
  end
  
  def work
    artist_id = params[:id]
    artist_id = current_artist.id if artist_id == 'your'
    
    @artist = Artist.find(artist_id)
    @current_work = Hash.new{|h,k| h[k] = []}
    @artist.reservations.each do |series|
      @current_work[series.state] << series
    end
    
    render 'work', :layout => !request.xhr?
  end
  
  def show
    artist_id = params[:id]
    artist_id = current_artist.id if artist_id == 'your'
    
    @artist = Artist.find(artist_id)
    
    @work = @artist.reservations
    @contributions = @artist.contribution_series
    @series = ((SpriteSeries.joins(:sprites).where('sprites.artist_id = ?', @artist.id) | @contributions) - @work).sort{|s1, s2| s2.updated_at <=> s1.updated_at}
  end
  
end
