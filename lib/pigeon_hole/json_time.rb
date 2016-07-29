module PigeonHole
  module JSONTime
    TYPE_VALUE = 'time'.freeze

    def self.serialize(time)
      {
        TypedJSON::TYPE_KEY => TYPE_VALUE,
        'ms' => (time.tv_sec * 1000) + (time.usec / 1000),
      }
    end

    def self.deserialize(hash)
      ms_since_epoc = hash['ms'].to_i
      seconds, fragment = ms_since_epoc.divmod(1000)
      Time.at(seconds, fragment * 1000).utc
    end
  end
end
