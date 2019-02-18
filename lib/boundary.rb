class Boundary
  attr_reader :lower, :upper

  def initialize
    @lower = nil
    @upper = nil
  end

  def worse?(value)
    if @lower.nil? || @lower > value
      @lower = value
      false
    else
      true
    end
  end
end
