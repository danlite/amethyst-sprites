require 'spec_helper'

describe UploadActivity do
  
  describe "validation" do
    before(:each) do
      @activity = Factory(:upload_activity)
    end
  
    it "should require a sprite" do
      @activity.sprite = nil
      @activity.should_not be_valid
    end
  end
  
end
