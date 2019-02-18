require_relative 'lib/vector.rb'
require_relative 'lib/salesman.rb'
require_relative 'lib/nearest.rb'
require_relative 'lib/trail.rb'
require_relative 'lib/boundary.rb'
require 'byebug'

vectors = [
[-6195.46875,-140.28125,16462.0625,'0'],

[-3718.34375,402.5625,18541.625,'A'],
[-3485.8125,-1146.46875,18698.53125,'B'],
[-3348.3125,-597.625,20071.09375,'C'],
[-2405.75,-960.28125,20272.84375,'D'],
[-1406.5625,-274.65625,20354.0625,'E'],

[-6029.1875,-10.90625,16424.65625,'F'],
[-4856,1313.3125,16504.65625,'G'],
[-5141.59375,-289.46875,19057.90625,'H'],
[-5337.375,-173.8125,19962.0625,'I'],
[-2516.53125,-966.15625,20884.71875,'J'],
[-2197.53125,-1186.40625,20979.34375,'K'],

[-1523.75,1340.6875,20976.59375,'WP6'],
].map { |points| Vector.new(*points) }

start = vectors.find{|v|v.name == '0'}
finish = vectors.find{|v|v.name == 'WP6'}
stops = vectors.select{|v| ![start, finish].include?(v) }

# stops.shuffle!
# puts stops.map{|s|s.name}.join(',')

original_trail = Trail.new(vectors)

nearest_neighbour = Nearest.new(start: start, stops: stops, finish: finish).calculate

nearest_neighbour_trail = Trail.new(nearest_neighbour.trail)

puts "Nearest Neighbour Trail: #{nearest_neighbour_trail.total_distance}"
puts nearest_neighbour_trail.trail.map{|s|s.name}.join(',')
puts nearest_neighbour_trail.total_distance
puts nearest_neighbour_trail.to_table

boundary = Boundary.new
boundary.update(nearest_neighbour_trail.total_distance)

routes = []
ticks = 0
salesman = Salesman.new(
  trail: [ vectors.first ],
  start: start,
  choices: stops,
  finish: finish,
  odometer: 0,
  boundary: boundary
).calculate do |route|
  ticks += 1
  if routes.size < 5 || route.odometer < routes.max{|a,b| a.odometer <=> b.odometer }.odometer
    routes << route
    routes.replace( routes.sort{|a,b| a.odometer <=> b.odometer }[0..4] )
  end
end

puts "Maximum ticks of #{ (vectors.length-2) } factorial: #{(1..(vectors.length-2)).inject(:*)}"
puts "Ticks performed: #{ticks}"
# puts routes

best_route_trail = Trail.new( routes.first.trail )
puts "Best Route Trail:"
puts best_route_trail.trail.map{|s|s.name}.join(',')
puts best_route_trail.total_distance
puts best_route_trail.to_table
