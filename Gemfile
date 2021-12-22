source 'https://rubygems.org'

gem 'rails', '7.0'

gem 'unicorn'

gem "sprockets-rails"
gem 'pg'
gem 'haml'
gem 'jquery-rails'
gem 'sass-rails'
gem 'font-awesome-sass', '~>5.15'
gem 'bootstrap', '~>5.0'
gem 'will_paginate', '~> 3.3'
gem "audited", '~>5.0'
# на гите пока 7 рельсы не вольют в апстрим
gem 'inherited_resources', ">= 1.13", github: 'activeadmin/inherited_resources'
gem 'devise', '~>4.0'
gem "devise-encryptable"
gem 'devise-token_authenticatable'
gem 'devise_saml_authenticatable'
gem 'ruby-ldap'
gem 'rabl'
gem 'simpleidn'

gem 'acts_as_list'
gem 'state_machine'

gem 'protected_attributes_continued' # attr_accessible backport
gem 'activemodel-serializers-xml'
gem 'rails-controller-testing'

gem 'nokogiri'

gem 'bootsnap'
gem 'mini_racer' # in place of nodejs 10+, light version of rubyracer

group :development, :test do
  gem "rspec-rails"
  gem 'rspec-collection_matchers'
  gem 'rspec-html-matchers' # legacy matchers

  gem 'listen'
  gem 'puma'

  gem 'pry'
  gem 'pry-byebug'
  gem 'saml_idp'
end

group :test do
  gem "factory_bot_rails"
  gem "turnip" # run gherkin (cucumber) features in rspec

  gem 'capybara'
  gem 'database_cleaner'

  gem 'simplecov', require: false
end

group :development, :deploy do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'rvm-capistrano', require: false
end
