require "json"
require "./hashr/version"

class Hashr
  getter obj : Hash(String, JSON::Any) | JSON::Any

  def initialize(obj : Hash(String, JSON::Any) | JSON::Any)
    @obj = obj
  end

  def initialize(obj)
    if obj.responds_to? :to_json
      @obj = JSON.parse(obj.to_json)
    else
      raise "passed object must convertable to a valid JSON::Any object use to_json."
    end
  end

  macro method_missing(key)
    def {{ key.id }}
      value = @obj[{{ key.id.stringify }}]
      # pp typeof(value)

      Hashr.new(value)
    end
  end

  def ==(other)
    @obj == other
  end

  def to_s(io)
    obj.to_s(io)
  end

  def inspect(io)
    obj.inspect(io)
  end

  # can't redefine nil?
  # def nil?
  #   obj.nil?
  # end
end
