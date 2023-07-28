require "./spec_helper"
require "json"

describe "Hashr" do
  it "works with Hash(String, JSON::Any)" do
    h = {
      "bar"          => "bar",
      "helloWorld"   => "baz",
      "array"        => ["1", "2", "3"],
      "literalValue" => {
        "falsey"   => false,
        "truthy"   => true,
        "integer"  => 100,
        "float"    => 1.23,
        "blank"    => "",
        "nilValue" => nil,
      },
    }
    value = Hashr.new({"foo" => JSON.parse(h.to_json)})

    value.is_a?(Hashr).should be_true
    value.foo.should eq h
    value.foo.is_a?(Hashr).should be_true
    value.foo.bar.should eq "bar"
    value.foo.bar.is_a?(Hashr).should be_true
    value.foo.array.should eq ["1", "2", "3"]
    value.foo.literalValue.integer.should eq 100
    value.foo.literalValue.float.should eq 1.23
    value.foo.literalValue.blank.should eq ""
    value.foo.literalValue.falsey.should be_false
    value.foo.literalValue.truthy.should be_true
    value.foo.literalValue.nilValue.should eq nil # => work!
    # value.foo.literalValue.nilValue.should be_nil # not work
  end

  it "works with JSON::Any" do
    h = {
      "bar"   => "bar",
      "baz"   => {"foo" => "hello"},
      "array" => ["1", "2", "3"],
    }
    value = Hashr.new(JSON.parse(h.to_json))

    value.bar.should eq "bar"
    value.bar.to_s.is_a?(String).should be_true
    value.bar.inspect.is_a?(String).should be_true
    value.baz.should eq({"foo" => "hello"})
    typeof(value.baz.obj).should eq(Hash(String, JSON::Any) | JSON::Any)
    value.array.should eq ["1", "2", "3"]
  end

  it "works with object which respond to #to_json" do
    h = {
      "bar"        => "bar",
      "helloWorld" => "baz",
      "array"      => ["1", "2", "3"],
    }
    value = Hashr.new(h)

    value.bar.should eq "bar"
    value.helloWorld.should eq "baz"
    value.array.should eq ["1", "2", "3"]
  end

  it "use hashr as model object" do
    contacts = [
      {
        id:    1,
        first: "billy",
        last:  "zheng",
        phone: "18612385678",
        email: "billy@gmail.com",
      },
      {
        id:    2,
        first: "xuan",
        last:  "zheng",
        phone: "18512345678",
        email: "retired@qq.com",
      },
    ]

    models = contacts.map { |e| Hashr.new(e) }

    models.each do |contact|
      puts "#{contact.first}.#{contact.last}: phone: #{contact.phone}, email: #{contact.email}"
    end

    billy = models.first
    puts billy.obj

    billy.phone = "13012345678"
    billy.phone.should eq "13012345678"
    puts billy
  end

  it "raise exception if key not exists" do
    h = {"foo" => "bar"}.to_json
    value = Hashr.new({"baz" => JSON.parse(h)})

    expect_raises(KeyError, %(Missing hash key: "foo")) do
      value.foo.should eq "bar"
    end

    expect_raises(KeyError, %(Missing hash key: "foo1")) do
      value.baz.foo1.should eq "bar"
    end
  end
end

class NewObject
end
