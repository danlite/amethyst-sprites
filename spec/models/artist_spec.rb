require 'spec_helper'

describe Artist do
  describe "validations" do
    before(:each) do
      @artist = Factory(:artist)
    end
    
    it "should require a name" do
      @artist.name = ''
      @artist.should_not be_valid
    end
  end
  
  describe "contributions" do
    it "should fetch series it contributed to" do
      @artist = Factory(:artist)
      @series = Factory(:sprite_series)
      @contributor = Contributor.create(:artist => @artist, :series => @series, :role => :editor)
      
      @artist.series_contributions.should == [@series]
    end
  end
  
  describe "sprite series" do
    it "should not be able to claim a Pokemon with active sprites" do
      sprite = Factory(:sprite)
      sprite.series.update_attributes(:state => :awaiting_qc)
      
      artist = Factory(:another_artist)
      artist.should_not == sprite.artist
      
      lambda do
        artist.claim_pokemon(sprite.series.pokemon).should be_nil
      end.should_not change(SpriteSeries, :count)
    end
    
    it "should have an upper limit of in-progress or reserved Pokemon" do
      artist = Factory(:artist)
      
      lambda do
        Artist::MAXIMUM_CONCURRENT_WORKS.times do |n|
          artist.claim_pokemon(Factory(:form_pokemon))
        end
      end.should change(SpriteSeries, :count).by(Artist::MAXIMUM_CONCURRENT_WORKS)
      
      artist.has_maximum_wip.should be_true
      
      lambda do
        artist.claim_pokemon(Factory(:form_pokemon))
      end.should_not change(SpriteSeries, :count)
    end
    
    it "should create the necessary models when claiming an available Pokemon" do
      pokemon = Factory(:form_pokemon)
      artist = Factory(:artist)
      
      lambda do
        
        new_series = artist.claim_pokemon(pokemon)
        new_series.should_not be_nil
        new_series.latest_sprite.should be_nil
        
      end.should change(SpriteSeries, :count).by(1)
      
    end
  end
end
