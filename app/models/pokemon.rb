class Pokemon < ActiveRecord::Base
  has_many :series, :class_name => "SpriteSeries" do
    def current
      where("state != ?", :archived).order("created_at DESC").limit(1)
    end
  end
  
  validates :name, :presence => true
  validates :dex_number, :presence => true
  
  def full_name
    form_name ? "#{name} (#{form_name})" : name
  end
end
