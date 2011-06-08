source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"
gem "bson",           '>= 1.3',  :platforms => :jruby # for non jruby apps, require bson_ext in your Gemfile to boost performance
gem "bson_ext",       '>= 1.3',  :platforms => :mri
gem 'mongoid'
# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "rspec", "~> 2.3.0"
  gem "yard", "~> 0.6.0"
  gem "bundler", "~> 1.0.0"
  gem "jeweler", "~> 1.6.0"
  gem "rcov", ">= 0"
end
