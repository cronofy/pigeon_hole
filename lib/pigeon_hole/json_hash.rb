module PigeonHole
  module JSONHash
    TYPE_VALUE = 'hash'.freeze

    def self.serialize(hash)
      values = hash.to_a

      values.each do |v|
        begin
          v[1] = TypedJSON.serialize_value(v[1])
        rescue TypedJSON::UnsupportedType => e
          raise e.add_key_context(v[0])
        end
      end

      {
        TypedJSON::TYPE_KEY => TYPE_VALUE,
        'v' => values
      }
    end

    def self.deserialize(hash)
      values = hash['v']

      values.each do |v|
        v[1] = TypedJSON.deserialize_value(v[1])
      end

      Hash[values]
    end
  end
end
