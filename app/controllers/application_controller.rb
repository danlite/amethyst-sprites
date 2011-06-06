class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_artist
  helper_method :authenticate_artist
  
  private
  
  def authenticate_artist
    if !current_artist
      redirect_to log_in_path(:continue => request.env['PATH_INFO']), :notice => "You must be logged in to view this page."
    end
  end
  
  def current_artist
    @current_artist ||= Artist.find(session[:user_id]) if session[:user_id]
  end
end
