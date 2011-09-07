require 'spec_helper'

describe Comment do

  describe "push notifications" do
  
    it "should create a CommentActivity after creation" do
      sprite = Factory(:sprite)
      lambda do
        Comment.create!(:commentable => sprite, :artist => Factory(:another_artist), :body => "Great sprite!!! :)")
      end.should change(CommentActivity, :count).by(1)
    end
  
  end
  
end
