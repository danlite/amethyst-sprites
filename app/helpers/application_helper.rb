module ApplicationHelper
  
  GALLERY_COLUMNS = 5
  
  def format_event_datetime(datetime)
    datetime.strftime("%b %e at %l:%M %p %Z")
  end
  
  def series_button(series, text, sprite, small = false, options = {})
    options[:class] = "btn sprite #{small ? 'small' : 'large'} " + options[:class].to_s
    link_to(series_path(:id => series), options) do
      things = []
      if sprite
        things << image_tag(sprite.image.url, :alt => '', :class => 'sprite')
      else
        things << content_tag(:div, '', :class => 'sprite-placeholder') if !small
      end
      things << tag(:br) if sprite and text
      things << text if text
      things.join.html_safe
    end
  end
  
  def progress_widget    
    @finished_series = SpriteSeries.where(:state => SERIES_DONE).count
    @total_pokemon = Pokemon.count
    render 'series/progress'
  end

end
