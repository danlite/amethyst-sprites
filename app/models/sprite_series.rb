class SeriesPokemonValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, options[:message] || "already has an active (non-archived) sprite series") unless
      value.current_series.blank? or value.current_series == record
  end
end

class SpriteSeries < ActiveRecord::Base
  include ActiveRecord::Transitions
  
  belongs_to :pokemon
  belongs_to :reserver, :class_name => "Artist"
  has_many :sprites, :class_name => "Sprite", :foreign_key => "series_id"
  
  state_machine do
    state :reserved
    state :working
    state :awaiting_edit
    state :editing
    state :awaiting_qc
    state :qc
    state :done
    state :archived
    
    event :begin_work do
      transitions :to => :working, :from => [:reserved], :guard => lambda { |series|
        series.latest_sprite and [SPRITE_WORK, SPRITE_EDIT].include?(series.latest_sprite.step) and series.latest_sprite.image?
      }
    end
    
    event :mark_for_edit do
      transitions :to => :awaiting_edit, :from => [:working], :guard => lambda { |series|
        series.latest_sprite and [SPRITE_WORK, SPRITE_EDIT].include?(series.latest_sprite.step) and series.latest_sprite.image?
      }
    end
    
    event :begin_edit do
      transitions :to => :editing, :from => [:awaiting_edit]
    end
    
    event :mark_for_qc do
      transitions :to => :awaiting_qc, :from => [:working, :awaiting_edit, :editing], :guard => lambda { |series|
        series.latest_sprite and [SPRITE_WORK, SPRITE_EDIT].include?(series.latest_sprite.step) and series.latest_sprite.image?
      }
    end
    
    event :begin_qc do
      transitions :to => :qc, :from => [:awaiting_edit, :awaiting_qc]
    end
    
    event :finish do
      transitions :to => :done, :from => [:qc], :guard => lambda { |series|
        series.latest_sprite and series.latest_sprite.step == SPRITE_QC and series.latest_sprite.image?
      }
    end
    
    event :archive do
      transitions :to => :archived, :from => [:working, :awaiting_edit, :editing, :awaiting_qc, :qc, :done]
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
  
  def owned?
    [SERIES_RESERVED, SERIES_WORKING, SERIES_EDITING, SERIES_QC].include? self.state
  end
  
  def artist_can_upload?(artist)
    artist and ((self.owned? and artist == self.reserver) or self.state == SERIES_AWAITING_EDIT or (self.state == SERIES_AWAITING_QC and artist.qc))
  end
  
  private
  
    def unreserve
      self.reserver = nil
    end
  
end