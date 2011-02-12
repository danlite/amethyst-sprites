require 'spec_helper'

describe Pokemon do
  describe "validation" do
    before(:each) do
      @pokemon = Factory(:form_pokemon)
    end
    
    it "should require a name" do
      @pokemon.name = ''
      @pokemon.should_not be_valid
    end
    
    it "should not require a form name" do
      @pokemon.form_name.should_not be_blank
      @pokemon.form_name = ''
      @pokemon.should be_valid
    end
    
    it "should require a pokedex number" do
      @pokemon.dex_number = nil
      @pokemon.should_not be_valid
    end
  end
  
  describe "sprite series" do
        
    it "should update its current series after creating a new series" do
      @pokemon = Factory(:pokemon)
      @series = SpriteSeries.create(:pokemon => @pokemon)
      @pokemon.reload.current_series.should == @series
    end
    
    it "should not create a new series if it has a current series" do
      @pokemon = Factory(:pokemon)
      @series = SpriteSeries.create(:pokemon => @pokemon)
      
      @pokemon.reload.current_series.should == @pokemon.current_series
      
      lambda do
        SpriteSeries.create(:pokemon => @pokemon)
      end.should_not change(SpriteSeries, :count)
    end
  end
end
