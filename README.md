# hashr

Hashr is a tiny class makes test on JSON response easier.

The name of `hashr` come from the awesome ruby gem [hashr](https://github.com/svenfuchs/hashr), though, AFAIK, use original code is not possible because Crystal very different with Ruby in some aspect.

This shard should only be used in spec.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     hashr:
       github: zw963/hashr
   ```

2. Run `shards install`

## Usage

Following is a example use graphql + spec-kemal

```crystal

require "hashr"
require "../spec_helper"

describe "daily reports" do
  it "query daily report" do
    report = ReportFactory.create

    post_json "/graphql", body: {query: "query { ... }"}

    p! typeof(response.body)  # => String
    
    p! response.body # => "{\"data\":{\"reportQuery\":{\"target\":{\"targetTotalCount\":47,\"processedTotalCount\":44,\"qualifiedTotalCount\":40}}}}"

    response_hash = Hash(String, JSON::Any).from_json(response.body) # => Get a hash like this:
    # {"data" => {
    #                "reportQuery" => {
    #                  "target" => {
    #                    "targetTotalCount" => report.target_total_count,
    #                    "processedTotalCount" => report.processed_total_count,
    #                    "qualifiedTotalCount" => report.qualified_total_count
    #                  }
    #                }
    #              }
    #     }
    
    # Instead, verify on the entire response result, we can verify on specified field only.
    parsed_response = Hashr.new(response)

    # Use nice dot method call.
    target = parsed_response.data.reportQuery.target
    
    target.processedTotalCount.should eq report.processed_total_count
    target.qualifiedTotalCount.should eq report.qualified_total_count
  end
end
```

## Limit

For verify a value is nil, you have to use `eq`, `be_nil` not work because Crystal don't allow us redefine #nil? method on any object.

```crystal
h = {"nilValue" => nil}.to_json
value = Hashr.new({"foo" => JSON.parse(h)})

value.foo.nilValue.should eq nil # => true
value.foo.nilValue.should be_nil    # => false
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/zw963/hashr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Billy.Zheng](https://github.com/zw963) - creator and maintainer
