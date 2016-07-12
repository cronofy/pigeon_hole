require 'rake'
require 'rspec'

require "#{Rake.application.original_dir}/lib/pigeonhole"

include PigeonHole

def random_integer
  rand(9999)
end

def random_time
  Time.now - random_integer
end

def random_date
  Date.today - random_integer
end

def random_date_time
  DateTime.now
end

def symbolize_hash(obj)
  if obj.is_a?(Hash)
    obj.inject({}) do |memo, (k,v)|
      memo[k.to_sym] = symbolize_hash(v)
      memo
    end
  else
    obj
  end
end
