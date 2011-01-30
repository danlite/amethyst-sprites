class Pokemon < ActiveRecord::Base
  belongs_to :current_series, :class_name => "SpriteSeries"
  has_many :series, :class_name => "SpriteSeries"
  
  validates :name, :presence => true
  validates :dex_number, :presence => true
  
  def full_name
    form_name ? "#{name} (#{form_name})" : name
  end
end
