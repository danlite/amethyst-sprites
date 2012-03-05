module ArtistsHelper
  
  def style_artist_name(artist, link = true)
    real_artist = artist.is_a? Artist
    classes = ['artist']
    if real_artist
      classes << 'artist-qc' if artist.qc
      classes << 'artist-admin' if artist.admin
    end
    link_to_if (link and real_artist), artist.name, artist, :class => classes.join(' '), :title => artist_title(artist)
  end
  
  def artist_title(artist)
    titles = []
    titles << "Project Admin" if artist.admin
    titles << "QC Artist" if artist.qc
    titles.join(" and ")
  end
  
end
