require 'spec_helper'

describe Activity do
  
  describe "push notifications" do
    
    it "should send a Pusher event after creation" do
      Pusher.should_receive(:"[]").with(ACTIVITY_CHANNEL)
      sprite = Factory(:sprite)
      UploadActivity.create!(:sprite => sprite, :series => sprite.series)
    end
    
    it "should not send a Pusher event if it is hidden" do
      Pusher.should_not_receive(:"[]").with(ACTIVITY_CHANNEL)
      sprite = Factory(:sprite)
      UploadActivity.create!(:sprite => sprite, :series => sprite.series, :hidden => true)
    end
    
  end
  
end