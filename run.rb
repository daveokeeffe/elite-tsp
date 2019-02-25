require_relative 'lib/vector.rb'
require_relative 'lib/salesman.rb'
require_relative 'lib/nearest.rb'
require_relative 'lib/trail.rb'
require_relative 'lib/boundary.rb'
require 'byebug'

vectors = [
# [-5476.1875,    -61.84375, 11929.84375, 'WP4'],
# 
# [-4990.84375,  -935.71875, 13387.15625, 'B'],
# [-5004.78125,  -551.6875,  15326.78125, 'C'],
# [-5377.90625, -1291.40625, 15398      , 'D'],
# [-5548.90625,  -734.40625, 15604.5    , 'E'],
# [-4697.03125,   876.25,    16056.4375 , 'F'],
# [-4257.84375,  1142.53125, 15908.625  , 'G'],
# [-6195.46875,  -140.28125, 16462.0625 , 'WP5'],
# 
# [-6189.0625,   -682.5625,  13809.84375, 'I'],
# [-5179.875,    -933.46875, 13505.5625 , 'J'],
# [-6703.5,      -157.84375, 14108.03125, 'K'],
# [-6664.46875,    39.53125, 17030.0625 , 'L'],

# WP5 -> WP6
# [-6195.46875,-140.28125,16462.0625,'WP5'],
# 
# [-3718.34375,402.5625,18541.625,'A'],
# [-3485.8125,-1146.46875,18698.53125,'B'],
# [-3348.3125,-597.625,20071.09375,'C'],
# [-2405.75,-960.28125,20272.84375,'D'],
# [-1406.5625,-274.65625,20354.0625,'E'],
# 
# [-6029.1875,-10.90625,16424.65625,'F'],
# [-4856,1313.3125,16504.65625,'G'],
# [-5141.59375,-289.46875,19057.90625,'H'],
# [-5337.375,-173.8125,19962.0625,'I'],
# [-2516.53125,-966.15625,20884.71875,'J'],
# [-2197.53125,-1186.40625,20979.34375,'K'],
# 
# [-1523.75,1340.6875,20976.59375,'WP6'],


[-1523.75,1340.6875,20976.59375,'WP6','The Dryau Awesomes','Dryau Ausms KG-Y e3390'],

[-815.75,1209.75,21491.84375,'a','Shrogaei Nebula Cluster A','Shrogaei FH-U e3-1421'],
[-811.625,816.21875,21024.53125,'b','Shrogaei Nebula Cluster B','Shrogaei BL-X e1-2343'],
[-521.96875,781.25,21328.4375,'c','Shrogaei Nebula Cluster C','Shrogaei HR-V e2-7758'],
[-593.78125,950.375,21728.40625,'d','Shrogaei Nebula Cluster D','Shrogaei QO-Q e5-3431'],
[-802.375,1033.3125,20905.1875,'e','Shrogaei Nebula Cluster E','Shrogaei VJ-Z e6712'],
[-857.65625,-912.875,22318.1875,'f','Gallonas','Hypoe Flyi HW-W e1-7966'],
[-1063.5,-463.84375,22719.8125,'g','Caeruleum Luna “Mysturji Crater”','HYPOE FLYI HX-T E3-295'],
[354.84375,-42.4375,22997.21875,'h','Great Annihilator','Great Annihilator'],
[-437.34375,199.53125,23539.96875,'i','Zunuae Nebula','Zunuae HL-Y e6903'],
[-699.4375,-239.34375,25402.09375,'j','Wulfric','Byoomao MI-S e4-5423'],
[25.21875,-20.90625,25899.96875,'k','Sagittarius A*','Sagittarius A*'],
[26.34375,-20.5625,25899.25,'WP7','Armstrong Landing (Waypoint 7)','STUEMEAE KM-W C1-342'],

[971.03125,613.21875,21307.3125,'l','Black in Green','Shrogea MH-V e2-1763'],
[825.09375,2023.78125,22254.09375,'m','The Clawed Hand Nebula','Hypuae Scrua FL-W d2-90'],
[-1920.59375,-2703.5625,23361.6875,'n','Dance of the Compact Quartet','Kyli Flyuae WO-A f39'],
[-401.84375,49.28125,25491.6875,'o','Insinnergy\'s World','Myriesly DQ-G d10-1240'],
[-1043.71875,124.9375,25279.4375,'p','Six Rings','Myriesly RY-S e3-5414'],
[-665.28125,-12.28125,25567.09375,'q','Emerald Remnant','Myriesly CL-P e5-4186'],
[-633.375,114.65625,25560.84375,'r','Fenrisulfur','Myriesly CL-P e5-7383'],

].map { |points| Vector.new(*points) }

start = vectors.find{|v|v.tag == 'WP6'}
finish = vectors.find{|v|v.tag == 'WP7'}
stops = vectors.select{|v| ![start, finish].include?(v) }

# stops.shuffle!
puts stops.map{|s|s.tag}.join(',')

original_trail = Trail.new(vectors)

nearest_neighbour = Nearest.new(start: start, stops: stops, finish: finish).calculate

nearest_neighbour_trail = Trail.new(nearest_neighbour.trail)

puts "Nearest Neighbour Trail: #{nearest_neighbour_trail.total_distance}"
puts nearest_neighbour_trail.details

puts "Max ticks (#{(vectors.length-2)} factorial): #{(1..(vectors.length-2)).inject(:*)}"
best_route = nearest_neighbour_trail

boundary = Boundary.new(nearest_neighbour_trail.total_distance)
boundary.on_update do |value|
  puts "New boundary: #{value}"
end

ticks = 0
tstart = Time.now
salesman = Salesman.new(
  trail: [ vectors.first ],
  start: start,
  choices: stops,
  finish: finish,
  odometer: 0,
  boundary: boundary
).calculate do |route|
  ticks += 1
  best_route = route
  puts Trail.new( best_route.trail ).details
end
tend = Time.now

puts "Ticks performed: #{ticks}"
puts "Duration: #{sprintf( "%0.03f", (tend-tstart))}s"
puts ''
best_route_trail = Trail.new( best_route.trail )
puts "Best Route Trail:"
puts best_route_trail.details
