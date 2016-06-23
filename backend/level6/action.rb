class Action
  attr_accessor :actor
  attr_accessor :type
  attr_accessor :amount

  def self.debit(from:, amount:)
    Action.new(from, 'debit', amount)
  end

  def self.credit(to:, amount:)
    Action.new(to, 'credit', amount)
  end

  def initialize(actor, type, amount)
    @actor = actor
    @type = type
    @amount = amount
  end

  # Compute the "diff" action between this action and other action
  # Both actions must be of same type
  def diff(other)
    if @type != other.type
      raise 'Both actions must be of same type.'
    end

    amount_diff = other.amount - @amount

    if @type == 'credit'
      if amount_diff < 0
        Action.debit(from: @actor, amount: amount_diff.abs)
      else
        Action.credit(to: @actor, amount: amount_diff.abs)
      end
    else
      if amount_diff > 0
        Action.debit(from: @actor, amount: amount_diff.abs)
      else
        Action.credit(to: @actor, amount: amount_diff.abs)
      end
    end
  end

  def to_hash
    return {
      :who => @actor,
      :type => @type,
      :amount => @amount
    }
  end
end