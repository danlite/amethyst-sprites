ACTIVITY_CHANNEL = "activity_channel"

class Activity < ActiveRecord::Base
  belongs_to :actor, :class_name => "Artist"
  belongs_to :sprite
  belongs_to :series, :class_name => "SpriteSeries"
  
  after_create :send_event
  
  scope :visible, where('hidden = ? or hidden IS NULL', false)
  
  protected
  
  def send_event
    Pusher[ACTIVITY_CHANNEL].trigger('activity', {:content => ActivityPushController.new(:id => self.id).show_activity}) unless hidden
  end
end
