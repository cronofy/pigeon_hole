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

describe "serializing datetimes" do
  let(:date_time) { random_date_time }

  subject { PigeonHole.generate(date_time: date_time) }

  it "serializes hash into a string" do
    result = subject
    expect(result).to_not be_empty
  end

  it "can be deserialized to a date_time" do
    result = subject
    hash = PigeonHole.parse(result)
    expect(hash["date_time"]).to be_a(DateTime)
    expect(hash["date_time"].to_date).to eq(date_time.to_date)
    expect(hash["date_time"].to_time.to_i).to eq(date_time.to_time.to_i)
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
