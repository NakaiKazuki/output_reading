source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'bcrypt'
gem 'bootsnap', require: false
gem 'bootstrap'
gem 'carrierwave'
gem 'coffee-rails'
gem 'faker'
gem 'faker-japanese'
gem 'font-awesome-sass'
gem 'jbuilder'
gem 'jquery-rails'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'mini_magick'
gem 'mysql2'
gem 'puma'
gem 'rails', '~> 6.0.3'
gem 'rails-i18n'
gem 'rakuten_web_service'
gem 'ransack'
gem 'sassc-rails'
gem 'turbolinks'
gem 'uglifier'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'listen'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'database_cleaner-active_record'
  gem 'webdrivers'
end

group :production, :staging do
  gem 'unicorn'
end

group :production do
  gem 'fog-aws'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
