# Require standard libraries plus Sinatra.

require 'appengine-rack'
require 'sinatra'

# Configure and run the application. Attention: Modify the version number
# whenever you want to test the live environment without breaking the current
# release...

AppEngine::Rack.configure_app(
  # :ssl_enabled => true,
  :application => '{{name}}',
  :precompilation_enabled => true,
  :version => '1')

require 'app'
 
run Sinatra::Application
