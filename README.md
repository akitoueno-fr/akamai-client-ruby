# Akamai::Client::Ruby
This ruby library is for severarl akamai services.  

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'akamai-client-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install akamai-client-ruby

## Usage
### PAPI
When you want to call PAPI API, you can do it by executing like following code.  
```
require "akamai/client"

# Initialize papi client
client = Akamai::Client::Papi.new(
  host: "akab-tpyy6hfoqtmdvzv3-2bn725f4thsj62j7.luna.akamaiapis.net",
  client_token: "akab-qh3uowismme6zvhw-ffrqa7vxmqqiz64j",
  client_secret: "Sw1CkY5IuoqriEZ7M6GFmEQ7CtSCh1C1h1Hy/glJ5nI=",
  access_token: "akab-s2pqvfnnhgcxbng5-miyyc5rnhhkdrhrs"
)

# List groups
client.list_groups

# List properties
client.list_properties(
  contract_id,
  group_id
)

# Get Rule tree
client.get_rule_tree(
  property_id,
  version,
  contract_id,
  group_id
)
```

Regarding to detail of PAPI API provided by Akamai, please refer https://developer.akamai.com/api/luna/papi/resources.html.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/akamai-client-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Akamai::Client::Ruby project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/akamai-client-ruby/blob/master/CODE_OF_CONDUCT.md).
