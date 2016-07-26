module PigeonHole
  class JSONTime < SimpleDelegator
    # Deserializes JSON string by converting time since epoch to Time
    def self.json_create(object)
      ms_since_epoc = object['ms'].to_i
      seconds, fragment = ms_since_epoc.divmod(1000)
      Time.at(seconds, fragment * 1000).utc
    end

    # Returns a hash, that will be turned into a JSON object and represent this
    # object.
    def as_json(*)
      {
        JSON.create_id => self.class.name,
        'ms' => (tv_sec * 1000) + (usec / 1000),
      }
    end

    # Stores class name (Time) with number of seconds since epoch and number of
    # microseconds for Time as JSON string
    def to_json(*args)
      as_json.to_json(*args)
    end
  end
end
