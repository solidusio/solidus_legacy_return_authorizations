source 'https://rubygems.org'

# gem 'spree', github: 'spree/spree', branch: 'master'
gem 'spree', path: '../spree'
# Provides basic authentication functionality for testing parts of your engine
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: 'master'

gemspec

group :test, :development do
  platforms :ruby_20, :ruby_21 do
    gem 'byebug'
  end
  platforms :ruby_19 do
    gem 'debugger'
  end
end
