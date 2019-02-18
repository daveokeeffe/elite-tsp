class Trail
  def initialize(vectors)
    @trail = vectors
  end
  attr_reader :trail, :odometer

  def each_path(&block)
    (trail.length-1).times do |i|
      block.yield(trail[i], trail[i+1])
    end
  end

  def map_path(&block)
    (trail.length-1).times.map do |i|
      block.yield(trail[i], trail[i+1])
    end
  end

  def distances
    map_path do |a,b|
      a.distance_to(b)
    end
  end

  def total_distance
    distances.sum
  end

  def inspect
    "#<Trail(\nstops: #{@trail.count},\ndistances:\n  #{distances.join("\n  ")},\n  total_distance: #{total_distance})>"
  end

  def to_s
    inspect
  end

  def to_table
    map_path do |a,b|
      %[#{a.name}\t#{b.name}\t#{a.distance_to(b)}]
    end
  end

  def details
    puts trail.map{|r|r.name}.join(',')
    puts "Total: #{total_distance}"
    puts to_table
  end
end
