module ActivitiesHelper

  def format_activity_feed_datetime(datetime)
    day = datetime.today? ? "Today" : datetime.strftime("%b %e")
    "#{day} at #{datetime.strftime("%l:%M %p %Z")}"
  end
  
  def button_for_activity(activity)
    if activity.is_a? UploadActivity
      series_button(activity.series, nil, activity.sprite, true)
    elsif activity.is_a? ProgressActivity
      reserved = activity.subtype == SERIES_RESERVED ? "Reserved" : nil
      series_button(activity.series, reserved, reserved ? nil : activity.series.latest_sprite, true)
    elsif activity.is_a? CommentActivity
      series_button(activity.comment.commentable.series, nil, activity.comment.commentable, true)
    end
  end
  
  def text_for_activity(activity)
    if activity.is_a? UploadActivity
      "#{activity.sprite.artist ? activity.sprite.artist.name : 'Someone'} uploaded a sprite for #{activity.sprite.series.pokemon.full_name}"
    elsif activity.is_a? ProgressActivity
      text_for_progress_activity(activity)
    elsif activity.is_a? CommentActivity
      "#{h(activity.comment.artist.name)}: &ldquo;#{h(activity.comment.body.truncate(70, :separator => ' '))}&rdquo;".html_safe
    else
      ""
    end
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
