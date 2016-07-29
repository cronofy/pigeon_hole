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

    SERIALIZERS = {
      Date => JSONDate,
      Time => JSONTime,
      Symbol => JSONSymbol,
    }.freeze

    def self.generate(obj, *args)
      hash_dup = serializable_value(obj)
      JSON.generate(hash_dup, *args)
    end

    def self.serializable_value(value)
      case value
      when *BASIC_TYPES
        value
      when Hash
        hash = {}

        value.each do |k, v|
          hash[k] = serializable_value(v)
        end

        hash
      when Array
        value.map { |av| serializable_value(av) }
      else
        unless serializer = SERIALIZERS[value.class]
          raise UnsupportedType.new(value.class)
        end

        serializer.new(value)
      end
    end
  end
end
