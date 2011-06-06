class SessionsController < ApplicationController
  def new
  end
  
  def create
    artist = Artist.authenticate(params[:name_or_email], params[:password])
    if artist
      session[:user_id] = artist.id
      
      redirect = params[:continue] ? params[:continue] : root_url
      
      redirect_to redirect, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid username/email or password"
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end
