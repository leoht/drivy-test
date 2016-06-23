class Action
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

  def to_hash
    return {
      :who => @actor,
      :type => @type,
      :amount => @amount
    }
  end
end