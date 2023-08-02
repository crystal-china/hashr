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
    {% if key.name.ends_with? "=" %}
      {% k = key.name.gsub(/=/, "").stringify %}
      def {{ key.name }}(value)
        v = JSON::Any.new(value)
        if @obj.as? Hash(String, JSON::Any)
          @obj.as(Hash(String, JSON::Any))[{{ k }}] = v
        else
          @obj.as(JSON::Any).as_h[{{ k }}] = v
        end
      end
    {% else %}
      def {{ key.name }}
        value = @obj[{{ key.name.stringify }}]

        Hashr.new(value)
      end
    {% end %}
  end

  def ==(other)
    @obj == other
  end

  def [](key)
    if @obj.as? Hash(String, JSON::Any)
      @obj.as(Hash(String, JSON::Any))[key]
    else
      @obj.as(JSON::Any).as_h[key]
    end
  end

  def to_s(io)
    @obj.to_s(io)
  end

  def inspect(io)
    @obj.inspect(io)
  end

  # can't redefine nil?
  # def nil?
  #   obj.nil?
  # end
end
