class UploadActivity < Activity
  validates :sprite, :presence => true
  validates :series, :presence => true
  
  after_create :update_pokemon
  
  protected
  
  def update_pokemon
    self.series.pokemon.update_attribute(:acted_on_at, Time.now)
  end
end
