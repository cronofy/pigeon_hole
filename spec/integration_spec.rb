require 'spec_helper'

describe "serializing dates" do
  let(:date) { random_date }

  subject { PigeonHole.generate(date: date) }

  it "serializes hash into a string" do
    result = subject
    expect(result).to_not be_empty
  end

  it "can be deserialized to a date time" do
    result = subject
    hash = PigeonHole.parse(result)
    expect(hash).to eq({ "date" => date })
    expect(hash["date"]).to be_a(Date)
  end
end

describe "serializing times" do
  let(:time) { random_time }

  subject { PigeonHole.generate(time: time) }

  it "serializes hash into a string" do
    result = subject
    expect(result).to_not be_empty
  end

  it "can be deserialized to a time" do
    result = subject
    hash = PigeonHole.parse(result)
    expect(hash).to eq({ "time" => time })
    expect(hash["time"]).to be_a(Time)
  end
end

describe "serializing symbols" do
  let(:symbol) { :a_symbol }

  subject { PigeonHole.generate(symbol: symbol) }

  it "serializes hash into a string" do
    result = subject
    expect(result).to_not be_empty
  end

  it "can be deserialized to a symbol" do
    result = subject
    hash = PigeonHole.parse(result)
    expect(hash).to eq({ "symbol" => symbol })
    expect(hash["symbol"]).to be_a(Symbol)
  end
end

describe "serializing arrays" do
  let(:array) { [:a_symbol, { "test" => :foo } ] }

  subject { PigeonHole.generate(array: array) }

  it "serializes hash into a string" do
    result = subject
    expect(result).to_not be_empty
  end

  it "can be deserialized to a array" do
    result = subject
    hash = PigeonHole.parse(result)
    expect(hash).to eq({ "array" => array })
    expect(hash["array"]).to be_a(Array)
  end
end

describe "serializing nested hashes" do
  let(:expected) do
    {
      foo: {
        bar: random_time,
        baz: :temp
      }
    }
  end

  subject { PigeonHole.generate(expected) }

  it "serializes hash into a string" do
    result = subject
    expect(result).to_not be_empty
  end

  it "can be deserialized to a symbol" do
    result = subject
    hash = PigeonHole.parse(result)

    expect(symbolize_hash(hash)).to eq(expected)
  end
end
