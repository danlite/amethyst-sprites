class Activity < ActiveRecord::Base
  belongs_to :actor, :class_name => "Artist"
  belongs_to :sprite
  belongs_to :series, :class_name => "SpriteSeries"
  
  after_create :send_event
  
  scope :visible, where('hidden = ? or hidden IS NULL', false)
  
  def event_type
    type ? type : 'Activity'
  end
  
  def event_parameters
    {}
  end
  
  protected
  
  def send_event
    Pusher[ACTIVITY_CHANNEL].trigger(event_type, {:content => ActivityPushController.new(:id => self.id).show_activity}.merge(event_parameters)) unless hidden
  end
end
