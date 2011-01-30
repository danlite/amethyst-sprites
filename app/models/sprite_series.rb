class SeriesPokemonValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, options[:message] || "already has an active (non-archived) sprite series") unless
      value.current_series.blank? or value.current_series == record
  end
end

class SpriteSeries < ActiveRecord::Base
  STATES = [
    :reserved,
    :working,
    :awaiting_edit,
    :editing,
    :awaiting_qc,
    :qc,
    :done,
    :archived
  ]
  
  belongs_to :pokemon
  has_many :sprites, :class_name => "Sprite", :foreign_key => "series_id"
  
  validates :pokemon_id, :presence => true
  validates :pokemon, :series_pokemon => true, :unless => Proc.new {|series| series.pokemon.nil? or series.state == :archived}
  validates :state, :inclusion => { :in => STATES }
  
  before_validation(:on => :create) do
    self.state ||= :reserved
  end
  
  after_save do
    self.pokemon.current_series = self.pokemon.series.where('state != ?', :archived).order('created_at DESC').first
    self.pokemon.save
  end
  
  def state
    s = read_attribute(:state)
    s ? s.to_sym : nil
  end
  
  def latest_sprite
    self.sprites.order("created_at DESC").first
  end
  
end