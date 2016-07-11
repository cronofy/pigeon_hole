require_relative 'pigeonhole/typed_json'
require_relative 'pigeonhole/json_date'
require_relative 'pigeonhole/json_datetime'
require_relative 'pigeonhole/json_symbol'
require_relative 'pigeonhole/json_time'

module PigeonHole
  def generate(obj, *args)
    TypedJSON.generate(obj, *args)
  end

  def parse(string)
    load(string)
  end

  def load(string)
    JSON.load(string)
  end
end
