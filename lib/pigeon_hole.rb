require 'json'

require_relative 'pigeon_hole/json_date'
require_relative 'pigeon_hole/json_symbol'
require_relative 'pigeon_hole/json_time'

require_relative 'pigeon_hole/typed_json'

module PigeonHole
  def self.generate(obj)
    TypedJSON.generate(obj)
  end

  def self.parse(string)
    if string.is_a?(Hash)
      string
    else
      TypedJSON.parse(string)
    end
  end
end
