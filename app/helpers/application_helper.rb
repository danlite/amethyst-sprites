module ApplicationHelper
  
  GALLERY_COLUMNS = 5
  
  def format_event_datetime(datetime)
    datetime.strftime("%b %e at %l:%M %p %Z")
  end
  
  def series_button(series, text, sprite, small = false, options = {})
    dim = small ? 80 : 160
    options[:class] = "button " + options[:class].to_s
    link_to(series_path(:id => series), options) do
      things = []
      things << image_tag(sprite.image.url, :style => "height: #{dim}px; width: #{dim}px; vertical-align: middle; padding: 4px; margin: 4px", :alt => '') if sprite
      things << tag(:br) if sprite and text
      things << text if text
      things.join.html_safe
    end
  end

end
