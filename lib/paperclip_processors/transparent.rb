module Paperclip
  class Transparent < Processor    
    def make
      return @file unless @attachment.instance.make_transparent
      @attachment.instance.make_transparent = false
      
      image = Magick::Image.from_blob(@file.read).first
      
      width = image.columns
      height = image.rows
      
      rects = [
        [0, 0, width, 1],
        [0, height - 1, width, 1],
        [0, 1, 1, height - 2],
        [width - 1, 1, 1, height - 2]]
      
      border_pixels = Hash.new(0)
      rects.each do |rect|
        pixels = image.get_pixels(*rect)
        pixels.each {|pixel| border_pixels[pixel] += 1 }
      end
      
      border_colour = nil
      greatest_count = 0
      border_pixels.each do |pixel, count|
        if count > greatest_count
          greatest_count = count
          border_colour = pixel
        end
      end
      
      # already seems to be transparent
      return @file if border_colour.opacity == Magick::QuantumRange
      
      temp = Tempfile.new("transparent-image")
      image.transparent(border_colour).write("png:"+temp.path)
      
      temp
    end
  end
end