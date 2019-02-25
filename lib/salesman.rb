require_relative 'boundary.rb'
class Salesman
  def initialize(trail: [], choices: [], start: nil, finish: nil, odometer: 0, boundary: Boundary.new)
    @trail = trail
    @choices = choices.sort{|a,b| start.distance_to(a) <=> start.distance_to(b) }
    @start = start
    @finish = finish
    @odometer = odometer
    @boundary = boundary
  end
  attr_accessor :odometer, :trail

  def calculate &block
    if @choices.count == 0
      @odometer = @odometer + @start.distance_to(@finish)
      return if @boundary.worse?(@odometer)
      @boundary.update(@odometer)
      @trail << @finish
      block.yield( self )
    else
      @choices.each do |choice|
        distance = @odometer + @start.distance_to(choice)
        next if @boundary.worse?(distance)
        Salesman.new(
          trail: ( @trail + [choice] ).flatten,
          start: choice,
          choices: @choices.select{ |v| v != choice },
          finish: @finish,
          odometer: distance,
          boundary: @boundary
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
