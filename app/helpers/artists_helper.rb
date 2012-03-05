module ArtistsHelper
  
  def style_artist_name(artist)
    classes = ['artist']
    classes << 'artist-qc' if artist.qc
    classes << 'artist-admin' if artist.admin
    content_tag(:span, artist.name, :class => classes.join(' '))
  end
  
  def artist_title(artist)
    titles = []
    titles << "Project Admin" if artist.admin
    titles << "QC Artist" if artist.qc
    titles.join(" and ")
  end
  
end
