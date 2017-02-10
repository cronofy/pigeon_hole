module PigeonHole
  class JSONSet
    TYPE_VALUE = 'set'.freeze

    def self.serialize(set)
      {
        TypedJSON::TYPE_KEY => TYPE_VALUE,
        'v' => set.to_a
      }
    end

    def self.deserialize(hash)
      hash['v']
    end
  end
end
