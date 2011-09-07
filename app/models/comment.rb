COMMENT_CHANNEL = "comment_channel"

class Comment < ActiveRecord::Base
  belongs_to :artist
  belongs_to :commentable, :polymorphic => true
  
  validates :body, :presence => true, :length => { :within => 1..5000 }
  
  after_create :send_event
  
  protected
  
  def send_event
    Pusher[COMMENT_CHANNEL].trigger('comment', {:sprite_id => self.commentable_id, :content => EventPushController.new(:id => self.id).show_comment})
  end
end
