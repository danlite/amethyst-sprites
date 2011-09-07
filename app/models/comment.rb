COMMENT_CHANNEL = "comment_channel"

class Comment < ActiveRecord::Base
  belongs_to :artist
  belongs_to :commentable, :polymorphic => true
  has_one :comment_activity, :dependent => :destroy
  
  validates :body, :presence => true, :length => { :within => 1..5000 }
  
  after_create :create_activity
  
  protected
  
  def create_activity
    CommentActivity.create(:comment => self)
  end
end
