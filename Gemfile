source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'rails', '~> 5.2.4', '>= 5.2.4.2'
gem 'puma', '~> 3.11'
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails' , '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rails-i18n'
gem 'jquery-rails'
gem 'bootstrap'
gem 'bcrypt'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'carrierwave'
gem 'mini_magick'
gem 'faker'
gem 'faker-japanese'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug' , platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.9.1'
  gem "factory_bot_rails"
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'webdrivers'
end

group :production do
  gem 'pg'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
