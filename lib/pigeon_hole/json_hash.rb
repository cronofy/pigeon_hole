module PigeonHole
  module JSONHash
    TYPE_VALUE = 'hash'.freeze

    def self.serialize(hash)
      {
        TypedJSON::TYPE_KEY => TYPE_VALUE,
        'v' => hash.to_a
      }
    end

    def self.deserialize(hash)
      Hash[hash['v']]
    end
  end
end
