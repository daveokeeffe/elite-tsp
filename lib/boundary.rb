class Boundary
  attr_reader :lower

  def initialize(lower)
    @lower = lower
  end

  def worse?(value)
    if @lower.nil? || @lower > value
      false
    else
      true
    end
  end

  def update(value)
    puts "New boundary: #{value}"
    @lower = value
  end
end
