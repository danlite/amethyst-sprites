class Sprite < ActiveRecord::Base
  SPRITE_DIMENSION = 160
  
  attr_accessor :make_transparent
  
  belongs_to :series, :class_name => "SpriteSeries", :foreign_key => "series_id"
  belongs_to :artist
  has_attached_file :image,
    :storage => Rails.env.test? ? :filesystem : :s3,
    :s3_credentials => {
      :bucket => ENV['S3_BUCKET'],
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :path => Rails.env.test? ? ":rails_root/tmp/:class/:pokemon-:id.png" : "/:class/:pokemon-:id.png",
    :styles => {:original => {:processors => [:transparent]}}
  
  validates :series, :presence => true
  validates :step, :inclusion => { :in => SPRITE_STEPS }
  validates_attachment_presence :image
  validate :image_properties, :if => Proc.new{|s| s.image.file? }
  
  after_destroy do
    series.reload
    series.destroy if series.sprites.empty?
    self.image.clear
  end
  
  protected
  
  def image_properties
    reload unless new_record?
    img_data = image.to_file.read
    img = Magick::Image.from_blob(img_data).first
    
    valid_size = img.rows == SPRITE_DIMENSION and img.columns == SPRITE_DIMENSION
    errors.add(:image, "must be 160x160 pixels") unless valid_size
    
    valid_format = img.format.match(/^PNG/) and img.alpha?
    errors.add(:image, "must be a transparent PNG") unless valid_format or make_transparent
    
    if valid_format and valid_size and not make_transparent
      rects = [[0, 0, 160, 1],
        [0, 159, 160, 1],
        [0, 1, 1, 158],
        [159, 1, 1, 158]]
        
      total_pixels, clear_pixels = 0.0, 0.0
      rects.each do |rect|
        pixels = img.get_pixels(*rect)
        total_pixels += pixels.size
        clear_pixels += pixels.select{|p| p.opacity == Magick::QuantumRange}.size
      end
      percent = clear_pixels / total_pixels
      
      errors.add(:image, "must have a transparent background") unless percent > 0.75
    end
    
    map = img.unique_colors
    errors.add(:image, "must have no more than 15 colours, not including 'transparent'") if map.columns > 16
    b64_colour_map = ActiveSupport::Base64.encode64(map.scale(10).to_blob)
    self.update_attribute :colour_map, b64_colour_map
  end
  
end
