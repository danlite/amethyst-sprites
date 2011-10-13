require Rails.root.join("lib/palette/palette")

class PaletteController < ApplicationController
  before_filter :authenticate_artist
  
  def index
    if params[:sprite_url]
      result = Palette.make(params[:sprite_url])
      @image_data = ActiveSupport::Base64.encode64(result[:palette].to_blob)
      @info = result[:info]
    end
    render 'choose'
  end
end
