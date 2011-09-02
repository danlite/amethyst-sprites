class Artist < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation
  MAXIMUM_CONCURRENT_WORKS = 6
  
  attr_accessor :password
  before_save :encrypt_password
  
  has_many :reservations, :class_name => "SpriteSeries", :foreign_key => "reserver_id"
  has_many :sprites
  has_many :contributions, :class_name => "Contributor"
  has_many :series_contributions, :through => :contributions, :source => :series
  
  validates :password, :presence => true, :confirmation => true, :on => :create
  validates :email, :presence => true, :uniqueness => true
  validates :name, :presence => true, :uniqueness => true
  
  def self.authenticate(name_or_email, password)
    user = find_by_email(name_or_email) || find_by_name(name_or_email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  
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
  
  def has_event_authorization?(event)
    event = event.to_sym
    return true if self.admin
    
    if [:archive, :finish, :begin_qc].include?(event)
      return self.qc
    end
    
    true    
  end
end
