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
  
  describe "Pokemon" do
    it "should not create a new series if there is an existing non-archived series for the same Pokemon" do
      @series = Factory(:sprite_series)
      @series.state = :editing
      
      lambda do
        @series.pokemon.series.create(:state => :reserved)
      end.should_not change(SpriteSeries, :count)
      
      lambda do
        @series.pokemon.series.create(:state => :archived)
      end.should change(SpriteSeries, :count)
    end
  end
  
  describe "sprites" do
    it "should get its latest sprite" do
      @series = Factory(:sprite_series)
      @artist = Factory(:artist)
      @series.sprites.create(:step => :work, :artist => @artist)
      latest = @series.sprites.create(:step => :edit, :artist => @artist)
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
      @series.state.should == :reserved
    end
    
    it "should create a sprite when it is created" do
      @series = @artist.claim_pokemon(@pokemon)
      @series.latest_sprite.should_not be_nil
    end
  end
end
