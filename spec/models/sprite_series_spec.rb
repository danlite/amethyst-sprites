require 'spec_helper'

describe SpriteSeries do
  describe "validation" do
    before(:each) do
      @series = Factory(:sprite_series)
    end
    
    it "should require a Pokemon" do
      @series.pokemon = nil
      @series.should_not be_valid
    end
    
    it "should require a valid state" do
      @series.state = :invalid_state
      @series.should_not be_valid
    end
  end
  
  describe "sprites" do
    it "should get its latest sprite" do
      @series = Factory(:sprite_series)
      @artist = Factory(:artist)
      @series.sprites.create(:step => SPRITE_WORK, :artist => @artist, :image => File.open(Rails.root.join('spec/fixtures', 'sprite.png')))
      latest = @series.sprites.create(:step => SPRITE_EDIT, :artist => @artist, :image => File.open(Rails.root.join('spec/fixtures', 'sprite.png')))
      @series.latest_sprite.should == latest
    end
  end
  
  describe "state process" do
    before(:each) do
      @pokemon = Factory(:pokemon)
      @artist = Factory(:artist)
    end
    
    it "should be reserved by default" do
      @series = SpriteSeries.create(:pokemon => @pokemon)
      @series.state.should == SERIES_RESERVED
    end
  end
end
