class ActivitiesController < ApplicationController
  
  def show
    @activity = Activity.find(params[:id])
    render :text => ActivityPushController.new(params).show
  end
  
  def index
    @activities = Activity.all
  end
  
end
