class Contributor < ActiveRecord::Base  
  belongs_to :series, :class_name => "SpriteSeries", :foreign_key => "series_id"
  belongs_to :artist
  
  validates :series, :presence => true
  validates :name, :presence => true, :unless => Proc.new {|contributor| contributor.artist}
  
  def name
    artist ? artist.name : read_attribute(:name)
  end
end
