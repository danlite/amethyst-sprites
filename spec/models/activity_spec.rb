require 'spec_helper'

describe Activity do
  
  describe "push notifications" do
    
    it "should send a Pusher event after creation" do
      Pusher.should_receive(:"[]").with(ACTIVITY_CHANNEL)
      
      UploadActivity.create!(:sprite => Factory(:sprite))
    end
    
  end
  
end