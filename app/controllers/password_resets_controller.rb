class PasswordResetsController < ApplicationController
  def new
  end
  
  def create
    artist = Artist.find_by_email(params[:email])
    artist.send_password_reset if artist
    redirect_to root_url, :notice => "Email sent with password reset instructions."
  end
  
  def edit
    @artist = Artist.find_by_password_reset_token!(params[:id])
  end
  
  def update
    @artist = Artist.find_by_password_reset_token!(params[:id])
    if @artist.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @artist.update_attributes(params[:artist])
      redirect_to log_in_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end

end
