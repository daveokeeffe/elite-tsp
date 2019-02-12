class Salesman
  def initialize(trail: [], choices: [], start: nil, finish: nil, odometer: 0)
    @trail = trail
    @choices = choices
    @start = start
    @finish = finish
    @odometer = odometer
  end
  attr_accessor :odometer, :trail

  def calculate &block
    if @choices.count == 0
      @odometer = @odometer + @start.distance_to(@finish)
      @trail << @finish
      block.yield( self )
    else
      @choices.map do |choice|
        Salesman.new(
          trail: ( @trail + [choice] ).flatten,
          start: choice,
          choices: @choices.select{ |v| v != choice },
          finish: @finish,
          odometer: @odometer + @start.distance_to(choice)
        ).calculate(&block)
      end
    end
    self
  end

  def inspect
    "#<Salesman(\nodometer: #{@odometer},\ntrail:\n  #{@trail.join("\n  ")},\nobject_id: #{"0x00%x" % (object_id << 1)})>"
  end

  def to_s
    inspect
  end
end
