source 'https://rubygems.org'

gem 'rails', '5.0.7.2'
# ruby 2.3 - на проде (powerdnsapp3/6) уже есть (не забыть что нужен полный рестарт при смене рубей)
# gem 'rails', '5.1.7'
# gem 'rails', '5.2.6'
# ruby 2.5
# ruby 2.6 - тоже есть на проде
# gem 'rails', '6.0.3.7'
# gem 'rails', '6.1.3.2'

gem 'unicorn'

group :assets do
  # asset pipeline же не используется?
  # gem 'sass-rails'
  # gem 'coffee-rails'
  # gem 'uglifier'
end

platforms :ruby do
  gem 'pg', '~> 0.11'
  # gem 'therubyracer'
end

# for rails 3.2
gem 'iconv'
gem 'rake', '< 11.0'
gem 'test-unit', '~> 3.0'
# end

gem 'haml'
gem 'jquery-rails'
gem 'will_paginate', '~> 3.0.3'
gem "audited", '~>4.0'
gem 'inherited_resources', '1.10.0' # remove version after ruby 2.4
gem 'devise', '~>4.0'
gem "devise-encryptable"
gem 'devise-token_authenticatable'
gem 'ruby-ldap'
gem 'rabl'
gem 'simpleidn'

gem 'acts_as_list', '~>0.9' # версия залочена до апгрейда ruby 2.4+
gem 'state_machine'
gem 'dynamic_form'

gem 'protected_attributes_continued' # attr_accessible backport
gem 'activemodel-serializers-xml'
gem 'rails-controller-testing'

gem 'nokogiri', '~>1.10.10' # до апгрейда ruby 2.5+

group :development, :test do
  gem "rspec-rails"
  gem 'rspec-collection_matchers'
  gem 'rspec-html-matchers' # legacy matchers
end

group :test do
  gem "factory_bot_rails", "~> 4.9"

  gem "turnip" # run gherkin (cucumber) features in rspec

  gem 'pry', '~>0.11.0' # для старых рельсов
  gem 'pry-byebug', '3.7.0' # разлочить версию после ruby 2.4+

  gem 'capybara', '3.15.1' # upgrade adter ruby
  gem 'database_cleaner'

  gem 'simplecov', '0.17.1', require: false # upgrade adter ruby
end

group :development, :deploy do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'rvm-capistrano', require: false
end
