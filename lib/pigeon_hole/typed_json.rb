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

    class DuplicatedKey < ArgumentError
      attr_reader :key

      def initialize(key)
        @key = key

        super("Hash has a duplicated key=#{key}")
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
      JSONSymbol::TYPE_VALUE => JSONSymbol,
      JSONTime::TYPE_VALUE => JSONTime,
    }.freeze

    SERIALIZERS = {
      Date => JSONDate,
      Symbol => JSONSymbol,
      Time => JSONTime,
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
        elsif value[TYPE_KEY] == JSONHash::TYPE_VALUE
          hash = JSONHash.deserialize(value)
          hash.each do |k,v|
            hash[k] = deserialize_value(v)
          end

          hash
        elsif value[TYPE_KEY] == JSONSet::TYPE_VALUE
          values = JSONSet.deserialize(value)
          values.map! { |v| deserialize_value(v) }.to_set
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
      when String
        value.tr("\u0000", "")
      when *BASIC_TYPES
        value
      when Hash
        hash = {}

        value.each do |k, v|
          if hash.key?(k.to_s) || hash.key?(k.to_sym)
            raise DuplicatedKey.new(k)
          end

          begin
            hash[k] = serialize_value(v)
          rescue UnsupportedType => e
            raise e.add_key_context(k)
          end
        end

        JSONHash.serialize(hash)
      when Set
        values = value.to_a.each_with_index.map do |sv, i|
          begin
            serialize_value(sv)
          rescue UnsupportedType => e
            raise e.add_index_context(i)
          end
        end

        JSONSet.serialize(values)
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
