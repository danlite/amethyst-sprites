require Rails.root.join("lib/palette/palette")

class PaletteController < ApplicationController
  before_filter :authenticate_artist
  
  def index
    if params[:sprite_url]
      @image_data = ActiveSupport::Base64.encode64(Palette.make(params[:sprite_url]).to_blob)
    end
    render 'choose'
  end
end
