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
  
  has_many :reservations, :class_name => "SpriteSeries", :foreign_key => "reserver_id"
  has_many :sprites
  has_many :contributions, :class_name => "Contributor"
  has_many :series_contributions, :through => :contributions, :source => :series
  
  validates :name, :presence => true, :uniqueness => true
  
  def has_maximum_wip
    current_wip = self.reservations.where('state IN (?)', [SERIES_WORKING, SERIES_EDITING, SERIES_RESERVED]).count
    return current_wip >= MAXIMUM_CONCURRENT_WORKS
  end
  
  def claim_pokemon(pokemon)
    return nil if has_maximum_wip
    
    series = SpriteSeries.create(:pokemon => pokemon, :reserver => self)
    
    return series if series.valid?
        
    nil
  end
end
