require 'spec_helper'
describe Money do

  before(:each) do
    Money.conversion_rates('EUR', {'USD'     => 1.11, 'Bitcoin' => 0.0047})
    @fifty_eur = Money.new(50, 'EUR')
    @twenty_dollars = Money.new(20, 'USD')
  end

  it "initialize static vars in money class" do
    expect(Money.class_variable_get(:@@base_currency)).to eq("EUR")
    expect(Money.class_variable_get(:@@currencies_rate)).to eq({'USD' => 1.11, 'Bitcoin' => 0.0047})
  end

  it "wrong parameters to conversion rates" do
    expect {Money.conversion_rates({'USD' => 1.11, 'Bitcoin' => 0.0047}, {'USD'=> 1.11, 'Bitcoin' => 0.0047})}.to raise_error(ArgumentError)
    expect {Money.conversion_rates('EUR', 'EUR')}.to raise_error(ArgumentError)
  end

  it "initialize object" do
    expect(@fifty_eur.amount).to eq(50)
    expect(@fifty_eur.currency).to eq("EUR")
    expect(@fifty_eur.inspect).to eq("50.00 EUR")
  end

  it "initialize object with wrong parameters" do
    expect {Money.new('EUR', 'EUR')}.to raise_error(ArgumentError)
    expect {Money.new(50, 50)}.to raise_error(ArgumentError)
  end

  it "converts to USD" do
    expect(@fifty_eur.convert_to('USD')).to eq(Money.new(55.50,"USD"))
  end


  it "fifty EUR + twenty USD" do
    expect(@fifty_eur + @twenty_dollars).to eq(Money.new(68.02,"EUR"))
  end

  it "fifty EUR - twenty USD" do
    expect(@fifty_eur - @twenty_dollars).to eq(Money.new(31.98,"EUR"))
  end

  it "fifty EUR / 2" do
    expect(@fifty_eur /2 ).to eq(Money.new(25,"EUR"))
  end

  it "twenty USD * 3" do
    expect(@twenty_dollars * 3 ).to eq(Money.new(60,"USD"))
  end

  it "twenty USD equal twenty USD" do
    expect(@twenty_dollars == Money.new(20, 'USD')).to eq(true)
  end

  it "twenty USD not equal twenty USD" do
    expect(@twenty_dollars == Money.new(30, 'USD')).to eq(false)
  end

  it "twenty USD bigger than five USD" do
    expect(@twenty_dollars > Money.new(5, 'USD')).to eq(true)
  end

  it "twenty_dollars less than fifty_eur " do
    expect(@twenty_dollars < @fifty_eur).to eq(true)
  end
end