require 'spec_helper'

describe UploadActivity do
  
  describe "validation" do
    before(:each) do
      @activity = Factory.build(:upload_activity)
      @activity.series = @activity.sprite.series
      @activity.actor = @activity.sprite.artist
    end
    
    it "should not require an actor" do
      @activity.actor = nil
      @activity.should be_valid
    end
  
    it "should require a sprite" do
      @activity.sprite = nil
      @activity.should_not be_valid
    end
    
    it "should require a series" do
      @activity.series = nil
      @activity.should_not be_valid
    end
  end
  
end
