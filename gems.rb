gem 'slim-rails'
#gem 'nokogiri'

gem 'kaminari'
gem 'newrelic_rpm'

gem 'therubyracer'
gem 'less-rails'
gem 'twitter-bootstrap-rails'

gem 'devise'
gem 'cancan'

gem 'simple_form'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'

gem 'rails-i18n'
gem 'devise-i18n'
# use gem > 0.2.6 for zh-CN translation
gem 'devise-i18n-views', git: 'https://github.com/mcasimir/devise-i18n-views.git'

gem 'ckeditor'
gem "carrierwave"
gem "mini_magick"

gem 'guard-livereload'
gem 'rack-livereload'

gem_group :development, :test do
  gem 'debugger'
  gem 'awesome_print'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'autotest'
end

gem_group :assets do
  gem 'turbo-sprockets-rails3'
end

gem_group :development do
  gem 'capistrano'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

run 'bundle install'

