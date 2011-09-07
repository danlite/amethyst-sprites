require 'spec_helper'

describe CommentActivity do

  describe "validation" do
    before(:each) do
      @activity = Factory(:comment_activity)
    end

    it "should require a comment" do
      @activity.comment = nil
      @activity.should_not be_valid
    end
  end
  
end
