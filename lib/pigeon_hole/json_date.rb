require 'date'

module PigeonHole
  module JSONDate
    TYPE_VALUE = 'date'.freeze

    def self.serialize(date)
      {
        TypedJSON::TYPE_KEY => TYPE_VALUE,
        'y' => date.year,
        'm' => date.month,
        'd' => date.day,
      }
    end

    def self.deserialize(hash)
      Date.new(hash['y'], hash['m'], hash['d'])
    end
  end
end
