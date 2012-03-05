module ArtistsHelper
  
  def style_artist_name(artist_or_contributor, link = true)
    artist_name = artist_or_contributor.name
    artist = artist_or_contributor.is_a?(Artist) ? artist_or_contributor : artist_or_contributor.artist
    classes = ['artist']
    if artist
      classes << 'artist-qc' if artist.qc
      classes << 'artist-admin' if artist.admin
    end
    link_to_if (link and artist), artist_name, artist, :class => classes.join(' '), :title => artist_title(artist)
  end
  
  def artist_title(artist)
    return '' unless artist
    titles = []
    titles << "Project Admin" if artist.admin
    titles << "QC Artist" if artist.qc
    titles.join(" and ")
  end
  
end
