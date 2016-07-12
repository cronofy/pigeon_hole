require 'json'

module PigeonHole
  class TypedJSON
    def self.generate(obj, *args)
      hash_dup = each_with_parent(obj)
      JSON.generate(hash_dup, *args)
    end

    def self.map_to_json(obj)
      case obj
      when Time
        JSONTime.new(obj)
      when DateTime
        JSONDateTime.new(obj)
      when Date
        JSONDate.new(obj)
      when Symbol
        JSONSymbol.new(obj)
      else
        obj
      end
    end

    def self.each_with_parent(hash, result=nil)
      duplicated_hash = {} || result

      hash.each do |k, v|
        case v
        when Hash
          duplicated_hash[k] = each_with_parent(v, duplicated_hash)
        else
          duplicated_hash[k] = map_to_json(v)
        end
      end

      duplicated_hash
    end
  end
end
