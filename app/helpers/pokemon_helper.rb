module PokemonHelper
  
  def html_for_series(series)
    state_text = case series.state
      when SERIES_RESERVED then "reserved"
      when SERIES_WORKING then "being worked on"
      when SERIES_AWAITING_EDIT then "awaiting edit"
      when SERIES_EDITING then "being edited"
      when SERIES_AWAITING_QC then "awaiting QC"
      when SERIES_QC then "in QC"
      when SERIES_DONE then "done"
      when SERIES_ARCHIVED then "archived"
      else "unknown state"
    end
    
    state_text += " by #{series.reserver.name}" if series.owned?
    
    state_text += " (limbo)" if series.limbo?
      
    state_text
  end
  
  def html_for_available(pokemon, artist)
    if artist.nil? or artist.has_maximum_wip
      "available"
    else
      link_to "available", claim_pokemon_path(pokemon)
    end
  end
  
end
