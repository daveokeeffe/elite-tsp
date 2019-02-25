class Vector
  attr_accessor :x, :y, :z, :tag, :name, :system
  def initialize(x, y, z, tag = nil, name = nil, system = nil)
    @x = x
    @y = y
    @z = z
    @tag = tag
    @name = name
    @system = system
  end

  def inspect
    "#<Vector(tag: #{@tag}, x: #{@x}, y: #{@y}, z: #{@z}, object_id: #{"0x00%x" % (object_id << 1)})>"
  end

  def to_s
    inspect
  end

  def distance_to(vector)
    Math.sqrt(
      (x - vector.x)**2 +
      (y - vector.y)**2 +
      (z - vector.z)**2
    )
  end

  def closest(vectors)
    sort_by_distance(vectors).first
  end

  def farthest(vectors)
    sort_by_distance(vectors).last
  end

  def sort_by_distance(vectors)
    vectors.sort{ |a,b| distance_to(a) <=> distance_to(b) }
  end

  def ==(other)
    x == other.x && y == other.y && z == other.z
  rescue NoMethodError
    false
  end

end
