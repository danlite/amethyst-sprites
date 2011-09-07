class ActivitiesController < ApplicationController
  
  def show
    @activity = Activity.find(params[:id])
    render :text => EventPushController.new(params).show_activity
  end
  
  def index
    @activities = Activity.visible.order("created_at DESC")
  end
  
end
