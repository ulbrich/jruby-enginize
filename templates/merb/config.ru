require 'rubygems'
require 'appengine-rack'

require 'merb-core'

AppEngine::Rack.configure_app(
    # :ssl_enabled => true,
    :application => '{{name}}',
    :version => 1)

Merb::Config.setup(:merb_root => File.dirname(__FILE__),
                   :environment => ENV['RACK_ENV'])

Merb.environment = Merb::Config[:environment]
Merb.root = Merb::Config[:merb_root]

Merb::BootLoader.run
 
run Merb::Rack::Application.new
