source 'https://rubygems.org'

gem 'spree', github: 'spree/spree', branch: '2-2-stable'

# Provides basic authentication functionality for testing parts of your engine
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '2-2-stable'

gemspec

group :test, :development do
  platforms :ruby_20, :ruby_21 do
    gem 'byebug'
  end
  platforms :ruby_19 do
    gem 'debugger'
  end
end
