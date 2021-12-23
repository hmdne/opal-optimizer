# Opal::Optimizer

A utility to optimize the JavaScript output from Opal with a help of RKelly-Turbo JavaScript parser.

As of now it contains two steps:

* Tree shaking for Opal methods - if a named method is not called anywhere in the code, it's removed
* Collapsing stubs

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'opal-optimizer'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install opal-optimizer

## Usage

For Sprockets environments, all you need is to `require "opal/optimizer/sprockets"` in your pipeline.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hmdne/opal-optimizer.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
