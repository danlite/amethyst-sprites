class Sprite < ActiveRecord::Base  
  belongs_to :series, :class_name => "SpriteSeries", :foreign_key => "series_id"
  belongs_to :artist
  has_attached_file :image,
    :storage => :s3,
    :s3_credentials => {
      :bucket => ENV['S3_BUCKET'],
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :path => "/:attachment/:filename"
  
  validates :artist, :presence => true
  validates :series, :presence => true
  validates :step, :inclusion => { :in => SPRITE_STEPS }
  
  after_destroy do
    series.reload
    series.destroy if series.sprites.empty?
    self.image = nil
  end
end
