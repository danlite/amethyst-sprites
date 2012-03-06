class SpriteSeriesObserver < ActiveRecord::Observer
  
  def after_update(series)
    if series.changes and series.changes['state']
      series.pokemon.update_attribute(:acted_on_at, Time.now)
      if series.changes['state'].include? SERIES_DONE
        ActionController::Base.new.expire_fragment 'total-progress'
      end
    end
  end
  
  def after_destroy(series)
    if series.state == SERIES_DONE
      ActionController::Base.new.expire_fragment 'total-progress'
    end
  end
  
end
