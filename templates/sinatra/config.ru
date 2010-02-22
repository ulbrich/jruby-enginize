require 'appengine-rack'

require 'sinatra'

AppEngine::Rack.configure_app(
  # :ssl_enabled => true,
  :application => '{{name}}',
  :precompilation_enabled => true,
  :version => '1')

require 'app'
 
run Sinatra::Application
