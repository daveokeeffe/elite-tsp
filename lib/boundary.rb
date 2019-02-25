class Boundary
  attr_reader :lower

  def initialize(lower)
    @lower = lower
    @_update_callbacks = []
  end

  def worse?(value)
    if @lower.nil? || @lower > value
      false
    else
      true
    end
  end

  def on_update(&block)
    @_update_callbacks << block
  end

  def update(value)
    @lower = value
    @_update_callbacks.each do |block|
      block.yield(value)
    end
    return @lower
  end
end
