require 'json'

require_relative 'pigeon_hole/json_date'
require_relative 'pigeon_hole/json_symbol'
require_relative 'pigeon_hole/json_time'

require_relative 'pigeon_hole/typed_json'

module PigeonHole
  def self.generate(obj, *args)
    TypedJSON.generate(obj, *args)
  end

  def self.parse(string)
    load(string)
  end

  def self.load(string)
    JSON.load(string)
  end
end
