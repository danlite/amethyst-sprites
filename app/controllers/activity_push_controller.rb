# http://amberbit.com/blog/render-views-partials-outside-controllers-rails-3

class ActivityPushController < AbstractController::Base
  attr_reader :params
  
  include AbstractController::Rendering
  include AbstractController::Helpers
  include AbstractController::AssetPaths
  include AbstractController::Logger
  include Rails.application.routes.url_helpers
  
  helper ApplicationHelper
  helper ActivitiesHelper

  self.view_paths = "app/views"
  
  def initialize(params)
    @params = params.dup
    config.assets_dir = Rails.root.join('public')
  end
  
  def show_activity
    @activity = Activity.find(params[:id])
    render :partial => "activities/activity", :locals => {:activity => @activity}
  end
  
  def show_full_activity
    @activity = Activity.find(params[:id])
    if @activity.is_a? CommentActivity
      render :partial => "comments/comment", :object => @activity.comment
    else
      render :text => ''
    end
  end
  
end