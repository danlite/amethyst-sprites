class ArtistsController < ApplicationController
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
  
end
