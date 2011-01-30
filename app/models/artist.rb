class Artist < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  MAXIMUM_CONCURRENT_WORKS = 8
  
  devise :database_authenticatable, :token_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  
  has_many :sprites
  has_many :contributions, :class_name => "Contributor"
  has_many :series_contributions, :through => :contributions, :source => :series
  
  validates :name, :presence => true
  
  def has_maximum_wip
    current_wip = self.sprites.joins(:series).where('sprite_series.state IN (?)', [:reserved, :working]).group('sprite_series.id').all
    return current_wip.count >= MAXIMUM_CONCURRENT_WORKS
  end
  
  def claim_pokemon(pokemon, start_work=false)
    return nil if has_maximum_wip
    
    state = start_work ? :working : :reserved
    series = SpriteSeries.create(:pokemon => pokemon, :state => state)
    if series.valid?
      sprite = Sprite.create(:artist => self, :series => series, :step => :work)
      return series
    end
    nil
  end
end