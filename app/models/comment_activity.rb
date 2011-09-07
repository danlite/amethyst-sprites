class CommentActivity < Activity
  belongs_to :comment
  
  validates :comment, :presence => true
  
  def event_parameters
    {:commentable_id => comment.commentable_id, :full_content => ActivityPushController.new(:id => id).show_full_activity}
  end
  
end
