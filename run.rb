require_relative 'lib/vector.rb'
require_relative 'lib/salesman.rb'
require 'byebug'

vectors = [
  [-5476.1875,    -61.84375, 11929.84375, 'A'],
  [-4990.84375,  -935.71875, 13387.15625, 'B'],
  [-5004.78125,  -551.6875,  15326.78125, 'C'],
  [-5377.90625, -1291.40625, 15398      , 'D'],
  [-5548.90625,  -734.40625, 15604.5    , 'E'],
  [-4697.03125,   876.25,    16056.4375 , 'F'],
  [-4257.84375,  1142.53125, 15908.625  , 'G'],
  [-6195.46875,  -140.28125, 16462.0625 , 'H'],

  [-6189.0625,   -682.5625,  13809.84375, 'I'],
  [-5179.875,    -933.46875, 13505.5625 , 'J'],
  [-6703.5,      -157.84375, 14108.03125, 'K'],
#  [-6664.46875,    39.53125, 17030.0625 , '11'], # this stop is past the final waypoint
].map { |points| Vector.new(*points) }

start = vectors.find{|v|v.name == 'A'}
finish = vectors.find{|v|v.name == 'H'}
stops = vectors.select{|v| ![start, finish].include?(v) }

routes = []
ticks = 0
puts "#{ (vectors.length-2) }!: #{(1..(vectors.length-2)).inject(:*)}"
salesman = Salesman.new(
  trail: [ vectors.first ],
  start: start,
  choices: stops,
  finish: finish,
  odometer: 0
).calculate do |route|
  ticks += 1
  if routes.size < 5 || route.odometer < routes.max{|a,b| a.odometer <=> b.odometer }.odometer
    routes << route
    routes.replace( routes.sort{|a,b| a.odometer <=> b.odometer }[0..4] )
  end
end

puts "Ticks: #{ticks}"
puts routes

