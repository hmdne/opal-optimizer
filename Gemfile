source "https://rubygems.org"

# Specify your gem's dependencies in opal-optimizer.gemspec
gemspec

gem "rake"
gem "rspec"

case ENV['OPAL_VERSION']
when nil
when /\A[0-9.]+\z/
  gem 'opal', "~> #{ENV['OPAL_VERSION']}.0a"
else
  gem 'opal', github: 'opal/opal', ref: ENV['OPAL_VERSION']
end
gem "opal-sprockets"
gem "opal-browser"

gem "rkelly-turbo"

gem "ruby-prof"
gem "pry"
