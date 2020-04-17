source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'rails', '~> 5.2.4', '>= 5.2.4.2'
gem 'puma', '~> 3.11'
gem 'sassc-rails' , '~> 2.1.2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails' , '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rails-i18n', '~> 5.1'
# gem 'bcrypt' , '~> 3.1.13'
# gem 'faker' , '~> 2.11.0'
# gem 'carrierwave' , '~> 2.1.0'
# gem 'mini_magick' , '~> 4.10.1'
# gem 'will_paginate' , '~> 3.3.0'
# gem 'bootstrap-will_paginate' , '~> 1.0.0'
# gem 'bootstrap-sass' , '~> 3.4.1'
# gem 'sass-rails', '~> 5.0'
# gem 'jquery-rails' , '~> 4.3.5'

group :development, :test do
  gem 'sqlite3' , '~> 1.4.2'
  gem 'byebug' , '~> 11.1.1' , platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring' , '~> 2.1.0'
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
