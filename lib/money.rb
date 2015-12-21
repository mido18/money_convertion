
class Money
  include Comparable
  attr_accessor :amount,:currency

  # This is an initialize method to Money class
  #
  # * *Args*    :
  #   - +amount+ -> the amount of money EX: 50
  #   - +currency+ -> the currencies type EX: EUR , USD
  # * *Raises* :
  #   - +ArgumentError+ -> if amount is not numeric or currency is not String or not predefined  currency
  #
  def initialize(amount,currency)
    raise(ArgumentError, "#{amount} must be a numeric") unless amount.is_a? Numeric
    validate_currency currency
    @amount = amount
    @currency = currency
  end

  # This is an class method is to initialize the default currency and the currencies rates
  #
  # * *Args*    :
  #   - +base_currency+ -> the default currency EX: EUR , USD
  #   - +currencies_rate+ -> the currencies rate EX: { 'USD' => 1.11, 'Bitcoin' => 0.0047}
  # * *Raises* :
  #   - +ArgumentError+ -> if base_currency is not String or currencies_rate is not Hash
  #
  def Money.conversion_rates(base_currency,currencies_rate)
    raise(ArgumentError, "#{base_currency} must be a string") unless base_currency.is_a? String
    raise(ArgumentError, "#{currencies_rate} must be a hash") unless currencies_rate.is_a? Hash
    @@base_currency = base_currency
    @@currencies_rate = currencies_rate
  end

  # This is an instance method is responsible to string representation
  #
  # * *Returns*    :
  #   - String representation for the instance
  #
  def to_s
    value = sprintf('%.2f', amount)
    "#{value} #{currency}"
  end

  # This is an instance method is responsible to string representation
  #
  # * *Returns*    :
  #   - String representation for the instance
  #
  def inspect
    value = sprintf('%.2f', amount)
    "#{value} #{currency}"
  end

  # This is an instance method that is responsible to exchange the currency
  #
  # * *Args*    :
  #   - +currency_symbol+ -> the default currency EX: EUR , USD
  # * *Returns*    :
  #   - Money object with the new currency and the new amount
  # * *Raises* :
  #   - +ArgumentError+ -> if currency_symbol is not String or currency_symbol not predefined currency
  #
  def convert_to(currency_symbol)
    validate_currency(currency_symbol)
    multiplier = @@currencies_rate[currency_symbol] unless @@currencies_rate[currency_symbol].nil?
    multiplier = 1 if currency_symbol == currency
    value = sprintf('%.2f', amount * multiplier).to_f
    Money.new value,currency_symbol
  end


  # This is an instance method that is responsible to do plus arithmetic operation
  #
  # * *Args*    :
  #   - +other+ -> money object
  # * *Returns*    :
  #   - Money object with the new amount
  # * *Raises* :
  #   - +ArgumentError+ -> if other is not money object
  #
  def +(other)
    raise(ArgumentError, "#{other} must be a money object") unless other.is_a? Money
    value = amount + (other.amount / @@currencies_rate[other.currency]).round(2)
    Money.new value,currency
  end

  # This is an instance method that is responsible to do minus operation
  #
  # * *Args*    :
  #   - +other+ -> money object
  # * *Returns*    :
  #   - Money object with the new amount
  # * *Raises* :
  #   - +ArgumentError+ -> if other is not money object
  #
  def -(other)
    raise(ArgumentError, "#{other} must be a money object") unless other.is_a? Money
    value = amount - (other.amount / @@currencies_rate[other.currency]).round(2)
    Money.new value,currency
  end

  # This is an instance method that is responsible to do division operation
  #
  # * *Args*    :
  #   - +num+ -> number
  # * *Returns*    :
  #   - Money object with the new amount
  # * *Raises* :
  #   - +ArgumentError+ -> if num is not number
  #
  def /(num)
    raise(ArgumentError, "#{num} must be a numeric") unless amount.is_a? Numeric
    value = (amount / num)
    Money.new value,currency
  end

  # This is an instance method that is responsible to do multiplication operation
  #
  # * *Args*    :
  #   - +num+ -> number
  # * *Returns*    :
  #   - Money object with the new amount
  # * *Raises* :
  #   - +ArgumentError+ -> if num is not number
  #
  def *(num)
    raise(ArgumentError, "#{num} must be a numeric") unless amount.is_a? Numeric
    value = (amount * num)
    Money.new value,currency
  end

  # This is an instance method that is responsible to do comparison between money objects
  #
  # * *Args*    :
  #   - +other+ -> money object
  # * *Returns*    :
  #   - true if objects are the same or false if not
  #
  def <=>(other)
    return amount <=> other.amount if currency == other.currency
    amount <=> other.convert_to(currency).amount if other.is_a? Money
  end

  private
    def validate_currency(currency)
      raise(ArgumentError, "#{currency} must be a string") unless currency.is_a? String
      raise(ArgumentError, "#{currency} must be a predefined as currency") unless currency == @@base_currency or @@currencies_rate.has_key? currency
    end

end
