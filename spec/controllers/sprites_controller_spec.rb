require 'spec_helper'

describe SpritesController do

  describe "sprite submission" do
    before(:each) do
      @series = Factory(:sprite_series)
      @artist = Factory(:another_artist)
      @series.reserver = @artist
      @series.save
      
      @image_data = fixture_file_upload(Rails.root.join('spec/sprite.png'), 'image/png')
      
      controller.stub!(:authenticate_artist).and_return(true)
      controller.stub!(:current_artist).and_return(@artist)
    end
    
    it "should add a new sprite to the series" do
      lambda do
        
        post :submit, :series_id => @series, :image => @image_data
        response.should redirect_to series_path(@series)
        
      end.should change(Sprite, :count).by(1)
    end
    
    it "should create an UploadActivity" do
      lambda { post :submit, :series_id => @series, :image => @image_data }.should change(UploadActivity, :count).by(1)
    end
  end

end
