class Contributor < ActiveRecord::Base
  ROLES = [
    :artist,
    :editor
  ]
  
  belongs_to :series, :class_name => "SpriteSeries", :foreign_key => "series_id"
  belongs_to :artist
  
  validates :series, :presence => true
  validates :artist, :presence => true
  validates :role, :inclusion => { :in => ROLES }
end
