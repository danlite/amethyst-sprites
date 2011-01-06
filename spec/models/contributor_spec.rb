require 'spec_helper'

describe Contributor do
  describe "validation" do
    before(:each) do
      @contributor = Factory(:contributor)
    end
    
    it "should require an artist" do
      @contributor.artist = nil
      @contributor.should_not be_valid
    end
    
    it "should require a series" do
      @contributor.series = nil
      @contributor.should_not be_valid
    end
    
    it "should require a valid role" do
      @contributor.role = :invalid_role
      @contributor.should_not be_valid
    end
  end
end
