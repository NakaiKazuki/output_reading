source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'rails', '~> 6.0.3', '>= 6.0.3.3'
gem 'puma'
gem 'sassc-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'bootsnap', require: false
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
gem 'sorcery'
gem 'font-awesome-sass'
gem 'ransack'
gem 'rakuten_web_service'
gem 'mysql2'

group :development, :test do
  gem 'byebug' , platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'mail-iso-2022-jp'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'webdrivers'
end

group :production do
  gem 'fog-aws'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
