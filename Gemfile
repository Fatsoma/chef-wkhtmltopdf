source 'https://rubygems.org'

gem 'rake'

group :test, :integration do
  gem 'berkshelf', '~> 4.0.1'
end

group :test do
  gem 'chefspec', '~> 4.0'
  gem 'foodcritic'
  gem 'rubocop'
end

group :integration do
  gem 'busser-serverspec', '~> 0.5'
  gem 'kitchen-vagrant', '~> 1.1'
  gem 'test-kitchen', '~> 1.16'
end

# group :development do
#   gem 'guard',         '~> 2.0'
#   gem 'guard-kitchen'
#   gem 'guard-rubocop', '~> 1.0'
#   gem 'guard-rspec',   '~> 3.0'
#   gem 'rb-inotify',    :require => false
#   gem 'rb-fsevent',    :require => false
#   gem 'rb-fchange',    :require => false
# end
