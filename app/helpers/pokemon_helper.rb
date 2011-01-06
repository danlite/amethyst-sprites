module PokemonHelper
  
  def html_for_series(series)
    state_text = case series.state
      when :reserved then "reserved"
      when :working then "being worked on"
      when :awaiting_edit then "awaiting edit"
      when :editing then "being edited"
      when :awaiting_qc then "awaiting QC"
      when :qc then "in QC"
      when :done then "done"
      when :archived then "archived"
      else "unknown state"
    end
    case series.state
      # TODO - validate series has sprite for these states
      when true
        true
      # when :reserved, :working, :editing, :qc
      #   state_text += " by #{series.latest_sprite.artist.name}"
    end
    state_text
  end
  
end
