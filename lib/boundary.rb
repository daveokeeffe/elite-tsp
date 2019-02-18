class Boundary
  attr_reader :lower, :upper

  def initialize
    @lower = nil
    @upper = nil
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
