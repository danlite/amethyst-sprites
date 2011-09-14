class SeriesPokemonValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, options[:message] || "already has an active (non-archived, non-limbo) sprite series") unless
      value.current_series.blank? or value.current_series == record or value.current_series.limbo?
  end
end

class SpriteSeries < ActiveRecord::Base
  include ActiveRecord::Transitions
  
  belongs_to :pokemon
  belongs_to :reserver, :class_name => "Artist"
  has_many :sprites, :class_name => "Sprite", :foreign_key => "series_id", :dependent => :destroy
  has_many :contributors, :foreign_key => "series_id", :dependent => :destroy
  has_many :activities, :foreign_key => "series_id", :dependent => :destroy
  
  scope :active, where('state NOT IN (?)', [SERIES_DONE, SERIES_ARCHIVED])
  scope :not_limbo, where('limbo IS NULL OR limbo = ?', false)
  
  state_machine do
    state :reserved
    state :working
    state :awaiting_edit
    state :editing
    state :awaiting_qc
    state :qc
    state :awaiting_approval
    state :done
    state :archived
    
    event :begin_work do
      transitions :to => :working, :from => [:reserved]
    end
    
    event :mark_for_edit do
      transitions :to => :awaiting_edit, :from => [:working, :editing], :guard => :has_working_sprite, :on_transition => :unreserve
    end
    
    event :begin_edit do
      transitions :to => :editing, :from => [:awaiting_edit, :awaiting_qc]
    end
    
    event :mark_for_qc do
      transitions :to => :awaiting_qc, :from => [:working, :awaiting_edit, :editing, :awaiting_approval], :guard => :has_working_sprite, :on_transition => :unreserve
    end
    
    event :begin_qc do
      transitions :to => :qc, :from => [:awaiting_edit, :awaiting_qc, :awaiting_approval]
    end
    
    event :mark_for_approval do
      transitions :to => :awaiting_approval, :from => [:awaiting_qc, :qc]
    end
    
    event :finish do
      transitions :to => :done, :from => [:awaiting_approval], :on_transition => [:unreserve, :unlimbo]
    end
    
    event :archive do
      transitions :to => :archived, :from => [:working, :awaiting_edit, :editing, :awaiting_qc, :qc, :awaiting_approval, :done], :on_transition => [:unreserve, :unlimbo]
    end
  end
  
  validates :pokemon_id, :presence => true
  validates :pokemon, :series_pokemon => true, :unless => Proc.new {|series| series.pokemon.nil? or series.state == SERIES_ARCHIVED}
  
  after_save do
    self.pokemon.current_series = self.pokemon.series.where('state != ?', SERIES_ARCHIVED).order('created_at DESC').first
    self.pokemon.save
  end
  
  def latest_sprite
    self.sprites.order("created_at DESC").first
  end
  
  def in_ownable_state?
    [SERIES_RESERVED, SERIES_WORKING, SERIES_EDITING, SERIES_QC].include? self.state
  end
  
  def owned?
    self.reserver and in_ownable_state?
  end
  
  def has_working_sprite
    self.latest_sprite and [SPRITE_WORK, SPRITE_EDIT].include?(self.latest_sprite.step)
  end
  
  def has_qc_sprite
    self.latest_sprite and self.latest_sprite.step == SPRITE_QC
  end
  
  def artist_can_upload?(artist)
    self.owned? and artist and artist == self.reserver
  end
  
  def events_for_artist(artist)
    return [] unless artist
    is_owner = artist == self.reserver
    
    machine = SpriteSeries.state_machines[:default]
    events = machine.events_for(self.state.to_sym)
    
    events.select do |event|
      case event
        when :archive, :finish then artist.admin
        when :begin_qc, :mark_for_approval then artist.qc
        when :mark_for_qc, :mark_for_edit then is_owner and has_working_sprite
        when :begin_work then is_owner
        when :begin_edit then state == SERIES_AWAITING_QC ? (latest_sprite and latest_sprite.artist == artist) : true
        else true
      end
    end
  end
  
  private
  
    def unreserve
      self.reserver = nil
    end
    
    def unlimbo
      self.limbo = false
    end      
  
end