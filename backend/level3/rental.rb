require 'date'

class Rental
  def initialize(id, car:, start_date:, end_date:, distance:)
    @id = id
    @car = car

    start_at = Date.parse(start_date)
    end_at = Date.parse(end_date)
    @days = (end_at - start_at).to_i + 1
    @distance = distance
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

  def to_hash
    return {
      :id => @id,
      :price => total_price,
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