require "./spec_helper"
require "json"

describe "Hashr" do
  it "hashr works" do
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

    value.foo.should eq h
    value.foo.bar.should eq "bar"
    value.foo.helloWorld.should eq "baz"
    value.foo.array.should eq ["1", "2", "3"]
    value.foo.literalValue.integer.should eq 100
    value.foo.literalValue.float.should eq 1.23
    value.foo.literalValue.blank.should eq ""
    value.foo.literalValue.falsey.should be_false
    value.foo.literalValue.truthy.should be_true
    value.foo.literalValue.nilValue.should eq nil # => work!
    # value.foo.literalValue.nilValue.should be_nil # not work
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
