module PigeonHole
  class JSONDateTime < SimpleDelegator
    # Deserializes JSON string by converting year <tt>y</tt>, month <tt>m</tt>,
    # day <tt>d</tt>, hour <tt>H</tt>, minute <tt>M</tt>, second <tt>S</tt>,
    # offset <tt>of</tt> and Day of Calendar Reform <tt>sg</tt> to DateTime.
    def self.json_create(object)
      ms_since_epoc = object['ms'].to_i
      seconds, fragment = ms_since_epoc.divmod(1000)
      Time.at(seconds, fragment * 1000).utc.to_datetime
    end

    # Returns a hash, that will be turned into a JSON object and represent this
    # object.
    def as_json(*)
      {
        JSON.create_id => self.class.name,
        'ms' => (to_time.tv_sec * 1000) + (to_time.usec / 1000),
      }
    end

    # Stores class name (DateTime) with Julian year <tt>y</tt>, month <tt>m</tt>,
    # day <tt>d</tt>, hour <tt>H</tt>, minute <tt>M</tt>, second <tt>S</tt>,
    # offset <tt>of</tt> and Day of Calendar Reform <tt>sg</tt> as JSON string
    def to_json(*args)
      as_json.to_json(*args)
    end
  end
end
