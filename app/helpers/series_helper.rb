module SeriesHelper
  
  def humanize_state_description(state)
    state.humanize.gsub(/[Qq]c/, "QC")
  end
  
  def text_for_activity(activity)
    if activity.is_a? UploadActivity
      activity.sprite.artist ? "uploaded by #{activity.sprite.artist.name}" : "sprite work by #{activity.series.contributors.map{|c| c.name }.join(", ")}"
    elsif activity.is_a? ProgressActivity
      text_for_series_progress_activity(activity)
    else
      ""
    end
  end
  
  def text_for_series_progress_activity(progress)
    actor = progress.actor.name
    
    case progress.subtype
    when SERIES_RESERVED
      "reserved by #{actor}"
    when SERIES_AWAITING_EDIT
      "edit requested by #{actor}"
    when SERIES_EDITING
      "began peer-editing by #{actor}"
    when SERIES_AWAITING_QC
      "QC requested by #{actor}"
    when SERIES_QC
      "moved into QC by #{actor}"
    when SERIES_AWAITING_APPROVAL
      "approval requested by #{actor}"
    when SERIES_DONE
      "approved by #{actor}"
    when SERIES_ARCHIVED
      "archived by #{actor}"
    else
      "something happened"
    end
  end
  
end
