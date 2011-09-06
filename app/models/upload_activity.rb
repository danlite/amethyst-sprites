class UploadActivity < Activity
  validates :sprite, :presence => true
  validates :series, :presence => true
end
