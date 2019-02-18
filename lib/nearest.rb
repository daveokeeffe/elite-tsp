class Nearest
  def initialize(start:nil, stops:[], finish:nil)
    @start = start
    @stops = stops
    @finish = finish
    @odometer = 0
    @trail = []
  end
  attr_reader :odometer, :trail

  def calculate
    remaining_stops = @stops.dup
    @trail << @start
    current = @start
    @stops.length.times do
      next_stop = remaining_stops.sort {|a,b| current.distance_to(a) <=> current.distance_to(b) }.first
      @trail << next_stop
      @odometer += current.distance_to(next_stop)
      
      current = next_stop
      remaining_stops.reject!{ |s| s == next_stop}
    end
    @odometer += current.distance_to(@finish)
    @trail << @finish
    self
  end

  def inspect
    "#<Nearest(\nodometer: #{@odometer},\ntrail:\n  #{@trail.join("\n  ")},\nobject_id: #{"0x00%x" % (object_id << 1)})>"
  end

  def to_s
    inspect
  end
end
