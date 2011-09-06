module ActivitiesHelper

  def format_activity_feed_datetime(datetime)
    day = datetime.today? ? "Today" : datetime.strftime("%b %e")
    "#{day} at #{datetime.strftime("%l:%M %p %Z")}"
  end
  
  def text_for_progress_activity(progress)
    pokemon = progress.series.pokemon.full_name
    text = case progress.subtype
    when SERIES_RESERVED
      "reserved #{pokemon}"
    when SERIES_AWAITING_EDIT
      "needs someone to edit #{pokemon}"
    when SERIES_EDITING
      "started editing #{pokemon}"
    when SERIES_AWAITING_QC
      "is ready for someone to QC #{pokemon}"
    when SERIES_QC
      "moved #{pokemon} into QC"
    when SERIES_DONE
      "approved the sprite for #{pokemon}"
    else
      "did something"
    end
    "#{progress.actor.name} #{text}"
  end

end
