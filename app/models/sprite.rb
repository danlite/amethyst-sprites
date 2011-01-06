class Sprite < ActiveRecord::Base
  STEPS = [
    :work,
    :edit,
    :qc
  ]
  
  belongs_to :series, :class_name => "SpriteSeries", :foreign_key => "series_id"
  belongs_to :artist
  has_attached_file :image
  
  validates :artist, :presence => true
  validates :series, :presence => true
  validates :step, :inclusion => { :in => STEPS }
end
