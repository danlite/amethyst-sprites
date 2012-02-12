module ApplicationHelper
  
  GALLERY_COLUMNS = 5
  
  def format_event_datetime(datetime)
    datetime.strftime("%b %e at %l:%M %p %Z")
  end
  
  def series_button(series, text, sprite, small = false, options = {})
    options[:class] = "btn sprite #{small ? 'small' : 'large'} " + options[:class].to_s
    link_to(series_path(:id => series), options) do
      things = []
      things << image_tag(sprite.image.url, :alt => '', :class => 'sprite') if sprite
      things << tag(:br) if sprite and text
      things << text if text
      things.join.html_safe
    end
  end

end
