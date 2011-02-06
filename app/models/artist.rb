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
    current_wip = self.sprites.joins(:series).where('sprite_series.state IN (?)', [SERIES_RESERVED, SERIES_WORKING]).count('sprite_series.id')
    return current_wip >= MAXIMUM_CONCURRENT_WORKS
  end
  
  def claim_pokemon(pokemon, start_work=false)
    return nil if has_maximum_wip
    
    series = SpriteSeries.create(:pokemon => pokemon)
    if series.valid?
      sprite = Sprite.create(:artist => self, :series => series, :step => :work)
      series.begin_work! if start_work
      return series
    end
    nil
  end
end
