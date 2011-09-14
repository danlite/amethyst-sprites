desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  # Get the non-limbo sprite series awaiting QC which have not been updated in the past three months
  limbo_candidates = SpriteSeries.not_limbo.where('state = ?', SERIES_AWAITING_QC).select{|s| s.latest_sprite.created_at < Time.now - LIMBO_TIME_FRAME}
  limbo_candidates.each do |limbo_series|
    Rails.logger.info "Putting #{limbo_series.pokemon.full_name} into Limbo (latest sprite: #{limbo_series.latest_sprite.created_at})"
    limbo_series.limbo = true
    limbo_series.save
  end
end