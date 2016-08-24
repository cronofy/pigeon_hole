module PigeonHole
  module JSONHash
    TYPE_VALUE = 'hash'.freeze

    def self.serialize(hash)
      {
        TypedJSON::TYPE_KEY => TYPE_VALUE,
        'value' => hash.to_a
      }
    end

    def self.deserialize(hash)
      Hash[hash['value']]
    end
  end
end
