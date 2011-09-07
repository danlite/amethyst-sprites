class CommentsController < ApplicationController
  before_filter :authenticate_artist
  before_filter :get_commentable
  
  layout false
  
  def new
    @comment = @commentable.comments.build(params[:comment])
  end

  def create
    @comment = Comment.new(params[:comment].merge(:commentable => @commentable, :artist_id => current_artist))
    
    success = false
    
    if @commentable.is_a? Sprite
      success = @commentable.commenting_open?
    else
      success = true
    end
    
    success &&= @comment.save
    
    respond_to do |format|
      format.json do
        render :json => {:success => success}
      end
    end
  end
  
  def show
    @comment = Comment.find(params[:id])
    
    render :partial => 'comment', :object => @comment
  end
  
  private
  
  def get_commentable
    if params[:sprite_id]
      @commentable = Sprite.find(params[:sprite_id])
    end
    
    redirect_to :root unless @commentable
  end

end
