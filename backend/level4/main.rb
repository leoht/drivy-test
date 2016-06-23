require "json"
require "./car"
require "./rental"

file = File.new 'data.json', 'r'
data = JSON.load(file)

rentals = []
cars = []

# Create cars index
data['cars'].each do |info|
  car_id = info['id']
  cars[car_id] = Car.new(car_id, price_per_day: info['price_per_day'], price_per_km: info['price_per_km'])
end

# Compute rentals
data['rentals'].each do |info|
  car_id = info['car_id']
  rental = Rental.new(info['id'], car: cars[car_id], start_date: info['start_date'], end_date: info['end_date'], distance: info['distance'], deductible_reduction: info['deductible_reduction'])
  rentals << rental.to_hash
end

# Save
out = File.new 'output.json', 'w'
out.write JSON.pretty_generate({ :rentals => rentals })