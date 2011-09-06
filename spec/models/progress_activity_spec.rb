require 'spec_helper'

describe ProgressActivity do
  
  describe "validation" do
    before(:each) do
      @activity = ProgressActivity.new
      sprite = Factory(:sprite)
      @activity.series = sprite.series
      @activity.actor = Factory(:another_artist)
      @activity.subtype = SERIES_EDITING
      @activity.save!
    end
    
    it "should require a series" do
      @activity.actor = nil
      @activity.should_not be_valid
    end
    
    it "should require an actor" do
      @activity.actor = nil
      @activity.should_not be_valid
    end
    
    it "should require a valid series state" do
      @activity.subtype = "INVALID_STATE_HAHAHA"
      @activity.should_not be_valid
    end
  end
  
end
