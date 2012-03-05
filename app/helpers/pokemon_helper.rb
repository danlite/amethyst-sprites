module PokemonHelper
  
  def state_text(series)
    state_text = case series.state
      when SERIES_RESERVED then "reserved"
      when SERIES_WORKING then "WIP"
      when SERIES_AWAITING_EDIT then "awaiting edit"
      when SERIES_EDITING then "in edit"
      when SERIES_AWAITING_QC then "awaiting QC"
      when SERIES_QC then "in QC"
      when SERIES_AWAITING_APPROVAL then "awaiting approval"
      when SERIES_DONE then "done"
      when SERIES_ARCHIVED then "archived"
      else "unknown state"
    end
  end
  
  def html_for_series(series)
    state_text = "available"
    
    if series
      state_text = state_text(series)
    end
      
    content_tag(:span, state_text)
  end
  
  def html_for_available(pokemon, artist)
    if artist.nil? or artist.has_maximum_wip
      "available"
    else
      link_to "available", claim_pokemon_path(pokemon)
    end
  end
  
  def series_label(series, show_reserver = false)
    text = nil
    label_class = ''
    limbo = false
    
    if series
      limbo = series.limbo?
      
      text = state_text(series)
      
      label_class = case series.state
        when SERIES_DONE then 'label-success'
        when SERIES_RESERVED, SERIES_WORKING, SERIES_EDITING, SERIES_QC then 'label-info'
        when SERIES_AWAITING_EDIT, SERIES_AWAITING_QC, SERIES_AWAITING_APPROVAL then 'label-important'
        when SERIES_ARCHIVED then ''
      end
    end
    
    tag = content_tag(:span, text, :class => "label #{label_class}")
    tag += ' '.html_safe + content_tag(:span, 'limbo', :class => "label label-warning") if limbo
    
    if show_reserver and series.reserver
      return tag + ' '.html_safe + content_tag(:span){ 'by '.html_safe + style_artist_name(series.reserver) }
    end
    
    tag
  end
  
end
