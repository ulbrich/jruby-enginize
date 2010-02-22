$LOAD_PATH << 'file:WEB-INF/lib/gems.jar!/bundler_gems/jruby/1.8/gems/rubygems-update-1.3.6/lib'

require 'rubygems'
gem 'rubygems-update'

require 'appengine-rack'

require 'merb-core'

class Merb::BootLoader::Logger < Merb::BootLoader
  def self.print_warnings
  end
end

AppEngine::Rack.configure_app(
  # :ssl_enabled => true,
  :application => '{{name}}',
  :precompilation_enabled => true,
  :version => '1')

Merb::Config.setup(:merb_root => File.dirname(__FILE__),
                   :environment => ENV['RACK_ENV'])

Merb.environment = Merb::Config[:environment]
Merb.root = Merb::Config[:merb_root]

Merb::BootLoader.run
 
run Merb::Rack::Application.new
