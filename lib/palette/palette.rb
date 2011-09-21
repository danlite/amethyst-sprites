module Magick
  class Draw
    
    def pixel_hex(x_offset, y_offset)
      size = Palette::PIXEL_HEX_SIZE
      size.times do |y|
        size.times do |x|
          # don't fill the corners
          next if (x == 0 or x == size - 1) and (y == 0 or y == size - 1)
          self.point(x_offset + x, y_offset + y)
        end
      end
      self
    end
    
  end
end

module Palette

  HUE = 0
  SATURATION = 1
  LIGHTNESS = 2

  LIGHTNESS_FLOOR = 25
  LIGHTNESS_CEILING = 240

  GREYNESS_THRESHOLD = 25

  HUE_FACTOR = 1.3
  SATURATION_FACTOR = 0.2
  LIGHTNESS_FACTOR = 0.4
  
  PIXEL_HEX_SIZE = 4

  class DotGroup < Set
    def self.connections_changed
      @@groups = nil
    end

    def mean
      return @mean if @mean

      sums = [0,0,0,0]
      self.each{|d| sums.each_with_index{|s,i| sums[i] = s + Dot.find(d).hsla[i]} }
      @mean = sums.map{|s| s.to_f / self.count }
    end

    def hue_standard_deviation
      return @hue_std_dev if @hue_std_dev

      dots = self.map{|did| Dot.find(did)}

      mean_hue = dots.reduce(0){|sum, d| d.hsla[HUE] + sum } / self.count

      Math.sqrt(
        dots.reduce(0){|sum, d| (d.hsla[HUE] - mean_hue)**2 + sum } / self.count
      )
    end

    def straightest_path

    end

    def self.all
      @@groups unless @@groups.nil?

      @@groups = []
      grouped_ids = Set.new
      Dot.list.each do |dot|
        id = dot.id
        next if grouped_ids.include?(id)

        group = dot.groupmates(DotGroup.new)
        group.each{|id| grouped_ids << id }

        @@groups << group
      end

      @@groups
    end

  end
  
  class Dot
    attr_accessor :rgb, :hsla, :id

    @@list
    @@connections

    def initialize(rgb, hsla)
      @rgb = rgb
      @hsla = hsla
    end

    def distance_from(dot, weighted = true)
      hf = weighted ? HUE_FACTOR : 1
      sf = weighted ? SATURATION_FACTOR : 1
      lf = weighted ? LIGHTNESS_FACTOR : 1

      Math.sqrt(
        ((self.hsla[HUE] - dot.hsla[HUE]) * hf)**2 +
        ((self.hsla[SATURATION] - dot.hsla[SATURATION]) * sf)**2 +
        ((self.hsla[LIGHTNESS] - dot.hsla[LIGHTNESS]) * lf)**2)
    end

    def extreme_lightness?
      self.hsla[LIGHTNESS] < LIGHTNESS_FLOOR or self.hsla[LIGHTNESS] > LIGHTNESS_CEILING
    end

    def grayscale?
      self.hsla[SATURATION] < GREYNESS_THRESHOLD or self.extreme_lightness?
    end

    def almost_grayscale?
      self.grayscale? or self.hsla[SATURATION] < (GREYNESS_THRESHOLD * 2)
    end

    def neighbours
      Dot.connections.map{|c| c[:dot_ids]}.select{|ids| ids.include?(self.id)}.flatten.uniq.delete_if{|d| d == self.id }
    end

    def groupmates(g)
      g << self.id

      ungrouped = Set.new(self.neighbours) - g

      ungrouped.each do |n|
        Dot.find(n).groupmates(g)
      end

      g
    end

    def self.find(id)
      @@list.find{|d| d.id == id}
    end

    def self.reset
      @@list = []
      @@connections = []
    end

    def self.add_dot(d)
      @@list << d
      DotGroup.connections_changed
    end

    def self.list
      @@list
    end

    def self.add_connection(c)
      @@connections << c
      DotGroup.connections_changed
    end

    def self.connections
      @@connections
    end

  end
  
  def Palette.make(image_or_url)
    image = image_or_url
    
    if image_or_url.is_a? String
      image = Magick::Image.from_blob(open(image_or_url).read)[0]
    end
    
    unique = image.unique_colors

    Dot.reset
    # Add all opaque colours into main list
    unique.columns.times do |x|
      p = unique.pixel_color(x, 1)
      Dot.add_dot Dot.new(p, p.to_hsla) unless p.opacity == Magick::QuantumRange
    end
    
    # Sort colours by hue
    Dot.list.sort! do |d1, d2|
      d1.hsla[HUE] <=> d2.hsla[HUE]
    end

    # Assign ids to colours
    Dot.list.each_with_index do |d, i|
      d.id = i
    end

    # Find largest gap between hues
    previous_hue = 0
    largest_hue_gap = 0..0
    (Dot.list + [Dot.new(nil, [360, 255, 255])]).each do |d|
      next if d.hsla[LIGHTNESS] < LIGHTNESS_FLOOR

      hue = d.hsla[HUE].to_i
      gap = previous_hue..hue
      largest_hue_gap = gap if gap.count > largest_hue_gap.count
      previous_hue = hue
    end

    # Move colours below middle of the gap up 360 degrees
    gap_middle = largest_hue_gap.first + largest_hue_gap.count / 2
    lower_colours = []
    Dot.list.reject! do |d|
      (d.hsla[HUE] < gap_middle and lower_colours << d)
    end

    if lower_colours
      lower_colours.each{|d| d.hsla[HUE] += 360; Dot.add_dot d }
    end

    # Find nearest k neighbours to each colour
    k = 1
    max_distance = 60
    Dot.list.each do |d|
      dot_connections = []
      Dot.list.each do |d2|
        next if (d.rgb <=> d2.rgb) == 0
        next if d.grayscale? or d2.grayscale?
        distance = d.distance_from(d2)
        dot_ids = [d.id, d2.id].sort
        dot_connections << {:d => distance, :dot_ids => dot_ids} if distance < max_distance
      end
      dot_connections.sort{|c1,c2| c1[:d] <=> c2[:d]}[0,k].each{|c| Dot.add_connection c }
    end

    Dot.connections.uniq!

    # No segregation allowed, group all the greys/blacks/whites together
    grey_dots = Set.new
    DotGroup.all.each{|g| d = g.first; grey_dots << d if g.count == 1 and Dot.find(d).grayscale? }
    grey_dots.each do |did|
      d = Dot.find(did)
      grey_dots.each do |did2|
        d2 = Dot.find(did2)
        next if (d.rgb <=> d2.rgb) == 0
        Dot.add_connection({:d => 1, :dot_ids => [did, did2].sort})
      end
    end

    Dot.connections.uniq!

    # Try to fit lone colours into nearby groups
    loners = DotGroup.all.select{|g| g != grey_dots and g.count == 1}.map{|g| g.first}
    loners.each do |loner_id|
      loner_dot = Dot.find(loner_id)

      if loner_dot.almost_grayscale? and not grey_dots.empty?
        Dot.add_connection({:d => 1, :dot_ids => [loner_id, grey_dots.first].sort})
        grey_dots << loner_id
        next
      end

      colourful_groups = DotGroup.all.select{|g| g.count > 1 && g != grey_dots }
      distance_results = []
      colourful_groups.each do |group|
        group.map{|did| Dot.find(did)}.each do |colourful_dot|
          distance = colourful_dot.distance_from(loner_dot)
          distance *= 1.5 if group == grey_dots
          distance_results << {
            :dot => colourful_dot,
            :distance => distance,
            :hue_distance => (colourful_dot.hsla[HUE] - loner_dot.hsla[HUE]).abs,
            :sat_difference => (colourful_dot.hsla[SATURATION] - loner_dot.hsla[SATURATION]).abs
          }
        end
      end
      closest_result = distance_results.sort{|r1, r2| r1[:distance] <=> r2[:distance] }.first
      if closest_result[:distance] < max_distance * 1.2
        Dot.add_connection({:d => 1, :dot_ids => [loner_id, closest_result[:dot].id].sort})
      end
    end

    Dot.connections.uniq!

    # Set up palette canvas
    palette_columns = []
    max_group_size = 4
    dot_groups = DotGroup.all.sort{|g1,g2| g1.mean[HUE] <=> g2.mean[HUE] }
    dot_groups.reject!{|g| g == grey_dots}
    dot_groups << grey_dots

    # Split large groups into smaller columns
    dot_groups.each do |group|
      ordered = group.to_a.map{|did| Dot.find(did)}.sort{|d1,d2| d2.hsla[LIGHTNESS] <=> d1.hsla[LIGHTNESS]}
      if ordered.count > max_group_size
        remainder = ordered.count / 2
        palette_columns << ordered[0..-(remainder+1)] << ordered[-remainder, remainder]
      else
        palette_columns << ordered
      end
    end

    palette_draw = Magick::Draw.new
    max_colours_per_column = palette_columns.map(&:count).max
    palette_height = max_colours_per_column * PIXEL_HEX_SIZE * 4
    palette_width = palette_columns.count * PIXEL_HEX_SIZE

    palette = Magick::Image.new(palette_width, palette_height) do
      self.background_color = 'transparent'
      self.format = 'png'
    end

    # Draw palette
    top_edge = palette_height / 2
    previous_count = nil
    palette_columns.each_with_index do |colours, column|
      x = column * (PIXEL_HEX_SIZE - 1)

      count = colours.count
      if previous_count
        diff = previous_count - count
        top_edge += (0.5 * PIXEL_HEX_SIZE * diff)

        if diff % 2 == 0
          top_edge += ((top_edge > palette_height / 2) ? -0.5 : 0.5) * PIXEL_HEX_SIZE
        end  
      end
      previous_count = count

      y = top_edge
      colours.each_with_index do |dot, row|
        palette_draw.fill(dot.rgb.to_color).stroke_opacity(0).pixel_hex(x, y)
        y += PIXEL_HEX_SIZE
      end
    end

    palette_draw.draw(palette)

    palette.trim(true)
  end
  
end