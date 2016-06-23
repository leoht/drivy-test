require 'date'
require './action'

class Rental
  def initialize(id, car:, start_date:, end_date:, distance:, deductible_reduction:)
    @id = id
    @car = car

    start_at = Date.parse(start_date)
    end_at = Date.parse(end_date)
    @days = (end_at - start_at).to_i + 1
    @distance = distance
    @deductible_reduction = deductible_reduction
  end

  def total_price
    time_price + @car.price_per_km * @distance
  end

  def commission_amount
    total_price * 30 / 100
  end

  def insurance_fee
    commission_amount / 2 
  end

  def assistance_fee
    @days * 100
  end

  def drivy_fee
    commission_amount - insurance_fee - assistance_fee
  end

  def deductible_reduction_fee
    @deductible_reduction ? 400 * @days : 0
  end

  # Compute rental actions for each actor
  def actions
    return [
      Action.debit(from: 'driver', amount: total_price + deductible_reduction_fee),
      Action.credit(to: 'owner', amount: total_price - commission_amount),
      Action.credit(to: 'insurance', amount: insurance_fee),
      Action.credit(to: 'assistance', amount: assistance_fee),
      Action.credit(to: 'drivy', amount: drivy_fee + deductible_reduction_fee)
    ]
  end

  def to_hash
    return {
      :id => @id,
      :price => total_price,
      :options => {
        :deductible_reduction => deductible_reduction_fee
      },
      :commission => {
        :insurance_fee => insurance_fee,
        :assistance_fee => assistance_fee,
        :drivy_fee => drivy_fee
      }
    }
  end

  private
    # Compute the final price for time component, with eventual discount
    def time_price
      price = 0

      @days.downto(1) do |day|
        disc = 0

        if day > 10
          disc = 50
        elsif day > 4
          disc = 30
        elsif day > 1
          disc = 10
        end
          
        price += @car.price_per_day - (@car.price_per_day * disc / 100)
      end

      return price
    end
end