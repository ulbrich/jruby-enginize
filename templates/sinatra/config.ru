require 'rubygems'
require 'appengine-rack'

require 'sinatra'

AppEngine::Rack.configure_app(
    :application => '{{name}}',
    # :ssl_enabled => true,
    :version => 1)

require 'app'
 
run Sinatra::Application
