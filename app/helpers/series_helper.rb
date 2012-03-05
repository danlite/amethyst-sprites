module SeriesHelper
  
  def humanize_state_description(state)
    state = state.dup
    state.gsub!(/^mark_for_/, "request_")
    
    state.humanize.gsub(/[Qq]c/, "QC")
  end
  
  def event_button_content(event)
    text = humanize_state_description(event)
    
    icon = 'icon-pencil'''
    if event == 'finish'
      icon = 'icon-ok'
    elsif event == 'archive'
      icon = 'icon-folder-open'
    elsif event.match(/^mark_for/)
      icon = 'icon-share'
    end
    
    content_tag(:i, nil, :class => "icon_white #{icon}") + " #{text}".html_safe
  end
  
  def text_for_series_activity(activity)
    if activity.is_a? UploadActivity
      artists = activity.sprite.artist ? style_artist_name(activity.sprite.artist) : activity.series.contributors.map{|c| style_artist_name(c) }.join(", ")
      action = activity.sprite.artist ? (activity.sprite.step == SPRITE_REVAMP ? 'revamped' : 'uploaded') : 'sprite work'
      "#{action} by #{artists}".html_safe
    elsif activity.is_a? ProgressActivity
      text_for_series_progress_activity(activity)
    else
      ""
    end
  end
  
  def text_for_series_progress_activity(progress)
    actor = style_artist_name(progress.actor)
    
    case progress.subtype
    when SERIES_RESERVED
      "reserved by #{actor}"
    when SERIES_AWAITING_EDIT
      "edit requested by #{actor}"
    when SERIES_EDITING
      "began editing by #{actor}"
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
    end.html_safe
  end
  
end
