require 'spec_helper'

describe Contributor do
  describe "validation" do
    before(:each) do
      @contributor = Factory(:contributor)
    end
    
    it "should require a series" do
      @contributor.series = nil
      @contributor.should_not be_valid
    end
    
    it "should require a name if it is not associated with an artist" do
      @contributor.name = nil
      @contributor.artist = nil
      @contributor.should_not be_valid
    end
    
    it "should be valid with no name, but an artist" do
      @contributor.name = nil
      @contributor.should be_valid
    end
  end
end
