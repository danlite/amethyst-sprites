class CommentActivity < Activity
  belongs_to :comment
  
  validates :comment, :presence => true
  
  after_create :update_pokemon
  
  def event_parameters
    {:commentable_id => comment.commentable_id, :full_content => ActivityPushController.new(:id => id).show_full_activity}
  end
  
  protected
  
  def update_pokemon
    self.comment.commentable.series.pokemon.update_attribute(:acted_on_at, Time.now) if self.comment.commentable.is_a? Sprite
  end
  
end
