source "https://rubygems.org"

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
gem "solidus", github: "solidusio/solidus", branch: branch

if branch == 'master' || branch >= "v2.0"
  gem "rails-controller-testing", group: :test
else
  gem "rails_test_params_backport"
  gem "rails", "~> 4.2.7"
end

case ENV['DB']
when 'mysql'
  gem 'mysql2'
when 'postgres'
  gem 'pg', '< 1.0'
end

group :development, :test do
  if branch < "v2.5"
    gem 'factory_bot', '4.10.0'
  else
    gem 'factory_bot', '> 4.10.0'
  end

  gem "pry-rails"
end

gemspec
