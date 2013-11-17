source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '~> 3.2.12'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.3.0'
end

gem 'sass-rails',   '~> 3.2.5'
gem 'bootstrap-sass', '~> 2.2.2.0'
gem 'compass-rails', '~> 1.0.3'

gem 'thin'
gem 'haml', '~> 4.0.0'
gem 'jquery-rails', '~> 2.2.0'
gem 'aws-sdk', "~> 1.20.0"
gem "paperclip", "~> 3.4.0"
gem "font-awesome-sass-rails", "~> 3.0.0.1"

gem "i18n-js", "~> 2.1.2"

# Devise authentication
gem 'devise', '~> 2.1.2'

gem 'rack-cors', :require => 'rack/cors'

# omniauth
gem 'omniauth', '~> 1.1.4'
gem 'omniauth-facebook', '~> 1.4.1'
gem 'omniauth-twitter', '~> 1.0.0'

# fabebook api
gem 'koala', "~> 1.6.0"

# twitter api
gem "twitter", "~> 4.6.0"

#gema paloma para organizar javascript
gem "paloma", "~> 1.2.5"

# conexión base de datos mongoDB
gem "mongoid", "~> 3.1.2"

# para seguir usuarios/grupos
gem 'mongo_followable', "~> 0.3.2"

# gestión de adjuntos
gem "mongoid-paperclip", "~> 0.0.8", :require => "mongoid_paperclip"
gem 'paperclip-dimension'

# paginación
gem "kaminari", "~> 0.14.1"

# gestiónde variables de entorno
gem "figaro", "~> 0.6.3"

# URL expander
gem "url_expander", "~> 0.1.5"
# URL shortener
gem "googl", "~> 0.6.3"
gem "httparty", "0.10.0"

# Geocoder
gem "geocoder", "~> 1.1.8"

group :development do
  gem 'thin'
end

group :production do
  gem 'unicorn'
end

# Monitorizar la aplicación en heroku
gem 'newrelic_rpm'

# Urls para seo
gem "mongoid_slug", "~> 3.2.0"
