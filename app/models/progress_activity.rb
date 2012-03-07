class ProgressActivity < Activity
  validates :actor, :presence => true
  validates :series, :presence => true
  validates :subtype, :inclusion => { :in => SERIES_STATES }
  
  after_create :update_pokemon
  
  protected
  
  def update_pokemon
    self.series.pokemon.update_attribute(:acted_on_at, Time.now) if self.subtype != SERIES_ARCHIVED
  end

end
