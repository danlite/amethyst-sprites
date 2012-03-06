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
  
  def style_artist_name(artist_or_contributor, options = {})
    artist_name = artist_or_contributor.name
    artist = artist_or_contributor.is_a?(Artist) ? artist_or_contributor : artist_or_contributor.artist
    classes = ['artist']
    if artist
      classes << 'artist-qc' if artist.qc
      classes << 'artist-admin' if artist.admin
    end
    title = options[:title] || artist_title(artist)
    link_to_if artist, artist_name, artist, :class => classes.join(' '), :title => title
  end
  
  def artist_title(artist)
    return '' unless artist
    titles = []
    titles << "Project Admin" if artist.admin
    titles << "QC Artist" if artist.qc
    titles.join(" and ")
  end

end
