# http://amberbit.com/blog/render-views-partials-outside-controllers-rails-3

class ActivityPushController < AbstractController::Base
  attr_reader :params
  
  include AbstractController::Rendering
  include AbstractController::Helpers
  include AbstractController::AssetPaths
  include AbstractController::Logger
  include Rails.application.routes.url_helpers
  
  helper ActivitiesHelper

  self.view_paths = "app/views"
  
  def initialize(params)
    @params = params.dup
    config.assets_dir = Rails.root.join('public')
  end
  
  def show
    @activity = Activity.find(params[:id])
    render :partial => "activities/#{@activity.type.underscore}", :locals => {:activity => @activity}
  end
  
end