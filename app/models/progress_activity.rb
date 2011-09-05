class ProgressActivity < Activity
  validates :actor, :presence => true
  validates :series, :presence => true
  validates :subtype, :inclusion => { :in => SERIES_STATES }
end
