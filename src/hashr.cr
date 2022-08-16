class Hashr
  getter obj

  def initialize(json : Hash(String, JSON::Any) | JSON::Any)
    @obj = json
  end

  macro method_missing(key)
    def {{ key.id }}
      value = obj[{{ key.id.stringify }}]

      Hashr.new(value)
    end
  end

  def ==(other)
    obj == other
  end

  # Can't redefine nil?
  # def nil?
  #   obj.nil?
  # end
end
