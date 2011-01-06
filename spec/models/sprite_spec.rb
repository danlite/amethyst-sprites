require 'spec_helper'

describe Sprite do
  describe "validation" do
    before(:each) do
      @sprite = Factory(:sprite)
    end
    
    it "should require a series" do
      @sprite.series = nil
      @sprite.should_not be_valid
    end
    
    it "should require an artist" do
      @sprite.artist = nil
      @sprite.should_not be_valid
    end
    
    it "should require a valid step" do
      @sprite.step = :invalid_step
      @sprite.should_not be_valid
    end
  end
end
