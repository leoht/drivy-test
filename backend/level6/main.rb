require "json"
require "./car"
require "./rental"

file = File.new 'data.json', 'r'
data = JSON.load(file)

rentals = []
cars = []
modifications = []

# Create cars index
data['cars'].each do |info|
  car_id = info['id']
  cars[car_id] = Car.new(car_id, price_per_day: info['price_per_day'], price_per_km: info['price_per_km'])
end

# Create rentals index
data['rentals'].each do |info|
  car_id = info['car_id']
  rental_id = info['id']
  rental = Rental.new(rental_id, car: cars[car_id], start_date: info['start_date'], end_date: info['end_date'], distance: info['distance'], deductible_reduction: info['deductible_reduction'])

  rentals[rental_id] = rental
end

# Compute rental modifications actions
data['rental_modifications'].each do |info|
  rental_id = info['rental_id']
  rental = rentals[rental_id]

  new_start_date = info.include?('start_date') ? info['start_date'] : rental.start_date
  new_end_date = info.include?('end_date') ? info['end_date'] : rental.end_date
  new_distance = info.include?('distance') ? info['distance'] : rental.distance

  # Get update actions for new rental data
  actions = rental.actions_for_update(start_date: new_start_date, end_date: new_end_date, distance: new_distance)

  modifications << {
    :id => info['id'],
    :rental_id => rental_id,
    :actions => actions.map! { |a| a.to_hash }
  }
end

# Save
out = File.new 'output.json', 'w'
out.write JSON.pretty_generate({ :rental_modifications => modifications })

