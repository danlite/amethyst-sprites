require 'spec_helper'

describe Activity do
  
  describe "push notifications" do
    
    it "should send a Pusher event after creation" do
      Pusher.should_receive(:"[]").with(ACTIVITY_CHANNEL)
      
      Activity.create!
    end
    
  end
  
end