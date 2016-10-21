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
  let(:input) do
    {
      "foo" => {
        "bar" => random_time,
        "baz" => :temp,
      },
      "empty" => {}
    }
  end

  subject { PigeonHole.generate(input) }

  it "serializes hash into a string" do
    result = subject
    expect(result).to_not be_empty
  end

  it "can be deserialized to a symbol" do
    result = subject
    hash = PigeonHole.parse(result)

    expect(hash).to eq(input)
  end
end

describe "serializing hashes with symbols" do
  let(:input) do
    {
      :foo => :temp
    }
  end

  subject { PigeonHole.generate(input) }

  it "serializes hash into a string" do
    result = subject
    expect(result).to_not be_empty
  end

  it "hash keys are converted to strings" do
    result = subject
    hash = PigeonHole.parse(result)

    expect(hash["foo"]).to eq(input[:foo])
    expect(hash.keys).to_not include(:foo)
  end
end

describe "serializing hashes with duplicated keys" do
  let(:input) do
    {
      :foo => :temp,
      "foo" => :bar
    }
  end

  subject { PigeonHole.generate(input) }

  it "raises an error on generation" do
    expect { subject }.to raise_error(PigeonHole::TypedJSON::DuplicatedKey)
  end
end

describe "preserving order of hashes" do
  let(:input) do
    {
      "zzz" => random_time,
      "aaa" => :temp,
    }
  end

  subject { PigeonHole.generate(input) }

  it "serializes hash into a string" do
    result = subject
    expect(result).to_not be_empty
  end

  it "can be deserialized to a symbol" do
    result = subject
    hash = PigeonHole.parse(result)

    expect(hash).to eq(input)
    expect(hash.keys.first).to eq("zzz")
    expect(hash.keys.at(1)).to eq("aaa")
  end
end

describe "can deserialize standard json hashes" do
  let(:json_string) { '{ "foo": 1 }' }

  it "can be deserialized to a symbol" do
    hash = PigeonHole.parse(json_string)

    expect(hash).to eq({ 'foo' => 1})
  end
end

describe "can serialize an empty hash efficiently" do
  let(:input) { Hash.new }

  subject { PigeonHole.generate(input) }

  it "serializes hash into a string" do
    result = subject
    expect(result).to_not be_empty
    expect(result).to eq('{}')
  end

end

describe "can deserialize an empty hash" do
  it "can be deserialized to a hash" do
    hash = PigeonHole.parse('{}')

    expect(hash).to eq({})
  end

  it "can deserialize legacy strings" do
    hash = PigeonHole.parse('{"*": "hash", "v": []}')

    expect(hash).to eq({})
  end
end

describe "serializing custom type" do
  CustomType = Struct.new(:name)

  context "in a hash" do
    let(:input) do
      {
        "nested" => {
          "custom" => CustomType.new("hello"),
        }
      }
    end

    subject { PigeonHole.generate(input) }

    it "raises an unsupported type error" do
      expect { subject }.to raise_error(PigeonHole::TypedJSON::UnsupportedType, "Serialization of CustomType is not supported - key=nested.custom")
    end
  end

  context "in an array" do
    let(:input) do
      {
        "nested" => [
          "string",
          1337,
          CustomType.new("hello"),
        ]
      }
    end

    subject { PigeonHole.generate(input) }

    it "raises an unsupported type error" do
      expect { subject }.to raise_error(PigeonHole::TypedJSON::UnsupportedType, "Serialization of CustomType is not supported - key=nested[2]")
    end
  end
end
