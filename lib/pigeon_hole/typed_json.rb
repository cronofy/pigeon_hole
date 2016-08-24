module PigeonHole
  class TypedJSON
    class UnsupportedType < ArgumentError
      attr_reader :key
      attr_reader :klass

      def initialize(key, klass)
        @key = key
        @klass = klass

        super("Serialization of #{klass} is not supported - key=#{key}")
      end

      def add_key_context(parent_key)
        add_context(parent_key)
      end

      def add_index_context(index)
        add_context("[#{index}]")
      end

      private

      def add_context(context)
        combined_key = [context, key].compact.join(".").sub(".[", "[")
        self.class.new(combined_key, klass)
      end
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
      if value[TYPE_KEY] == JSONHash::TYPE_VALUE
        translate(JSONHash.deserialize(hash))
      else
        translate(hash)
      end
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
        elsif value[TYPE_KEY] == JSONHash::TYPE_VALUE
          hash = JSONHash.deserialize(value)
          hash.each do |k,v|
            hash[k] = deserialize_value(v)
          end

          hash
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
          begin
            hash[k] = serialize_value(v)
          rescue UnsupportedType => e
            raise e.add_key_context(k)
          end
        end

        JSONHash.serialize(hash)
      when Array
        value.each_with_index.map do |av, i|
          begin
            serialize_value(av)
          rescue UnsupportedType => e
            raise e.add_index_context(i)
          end
        end
      else
        unless serializer = SERIALIZERS[value.class]
          raise UnsupportedType.new(nil, value.class)
        end

        serializer.serialize(value)
      end
    end
  end
end
