source 'https://rubygems.org'

gem 'rails', '4.1.8'

gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
# gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

gem 'slim'
gem 'foundation-rails'

gem 'pg'

gem 'seed_dumper'

gem 'delayed_job_active_record'

# NLP / Algorithm Gems
gem 'ots'
gem 'whatlanguage'
gem 'sanitize'
gem 'unidecoder'
gem 'simple_sentiment'
gem 'sad_panda'
gem 'sentiment_lib'
gem 'sentimental'
gem 'engtagger', :git => 'https://github.com/charlieegan3/engtagger.git', group: :development
gem 'punkt-segmenter'

gem 'googleajax'
gem 'badfruit', :git => 'https://github.com/IllegalCactus/BadFruit.git'

group :production do
  gem 'rails_12factor'
  gem 'httparty'
  gem 'foreman'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'vcr'
  gem 'capybara'
end

group :test do
  gem 'webmock'
end

group :doc do
  gem 'sdoc', '~> 0.4.0'
end
