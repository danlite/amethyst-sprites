require 'spec_helper'

describe Comment do

  describe "push notifications" do
  
    it "should send a Pusher event after creation" do
      Pusher.should_receive(:"[]").with(COMMENT_CHANNEL)
      sprite = Factory(:sprite)
      Comment.create!(:commentable => sprite, :artist => Factory(:another_artist), :body => "Great sprite!!! :)")
    end
  
  end
  
end
