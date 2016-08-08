module PigeonHole
  class TypedJSON
    class UnsupportedType < ArgumentError
    end

    BASIC_TYPES = [
      NilClass,
      String,
      Integer,
      Fixnum,
      Bignum,
      Float,
      TrueClass,
      FalseClass,
    ].uniq.freeze

    DESERIALIZERS = {
      JSONDate::TYPE_VALUE => JSONDate,
      JSONTime::TYPE_VALUE => JSONTime,
      JSONSymbol::TYPE_VALUE => JSONSymbol,
    }.freeze

    SERIALIZERS = {
      Date => JSONDate,
      Time => JSONTime,
      Symbol => JSONSymbol,
    }.freeze

    TYPE_KEY = '*'.freeze

    def self.generate(obj, *args)
      hash_dup = serialize_value(obj)
      JSON.generate(hash_dup, *args)
    end

    def self.parse(value)
      hash = JSON.parse(value)
      translate(hash)
    end

    def self.translate(hash)
      deserialize_value(hash)
    end

    private

    def self.deserialize_value(value)
      case value
      when Hash
        if deserializer = DESERIALIZERS[value[TYPE_KEY]]
          deserializer.deserialize(value)
        else
          value.each do |k, v|
            value[k] = deserialize_value(v)
          end

          value
        end
      when Array
        value.map! { |av| deserialize_value(av) }
      else
        value
      end
    end

    def self.serialize_value(value)
      case value
      when *BASIC_TYPES
        value
      when Hash
        hash = {}

        value.each do |k, v|
          hash[k] = serialize_value(v)
        end

        hash
      when Array
        value.map { |av| serialize_value(av) }
      else
        unless serializer = SERIALIZERS[value.class]
          raise UnsupportedType.new("Serialization of #{value.class} is not supported")
        end

        serializer.serialize(value)
      end
    end
  end
end
