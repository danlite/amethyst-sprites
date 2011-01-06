class Artist < ActiveRecord::Base
  MAXIMUM_CONCURRENT_WORKS = 8
  
  has_many :sprites
  has_many :contributions, :class_name => "Contributor"
  has_many :series_contributions, :through => :contributions, :source => :series
  
  validates :name, :presence => true
  
  def claim_pokemon(pokemon, start_work=false)
    current_wip = self.sprites.joins(:series).where('sprite_series.state IN (?)', [:reserved, :working])
    return nil unless current_wip.count < MAXIMUM_CONCURRENT_WORKS
    
    state = start_work ? :working : :reserved
    series = SpriteSeries.create(:pokemon => pokemon, :state => state)
    if series.valid?
      sprite = Sprite.create(:artist => self, :series => series, :step => :work)
      return series
    end
    nil
  end
end
