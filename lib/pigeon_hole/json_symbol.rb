module PigeonHole
  module JSONSymbol
    TYPE_VALUE = 'sym'.freeze

    def self.serialize(symbol)
      {
        TypedJSON::TYPE_KEY => TYPE_VALUE,
        's' => symbol.to_s,
      }
    end

    def self.deserialize(hash)
      hash['s'].to_sym
    end
  end
end
