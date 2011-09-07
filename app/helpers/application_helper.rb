module ApplicationHelper
  
  def format_event_datetime(datetime)
    datetime.strftime("%b %e at %l:%M %p %Z")
  end
  
  def series_button(series, text, sprite, small = false, style = '')
    dim = small ? 80 : 160
    link_to(series_path(:id => series), :class => "button", :style => style) do
      things = []
      things << image_tag(sprite.image.url, :style => "height: #{dim}px; weight: #{dim}px; vertical-align: middle; padding: 4px; margin: 4px") if sprite
      things << tag(:br) if sprite and text
      things << text if text
      things.join.html_safe
    end
  end

end
