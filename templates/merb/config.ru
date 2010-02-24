# Modify load paths to help Merb do some Gem extension work.

require 'rubygems'
gem 'rubygems-update'

$LOAD_PATH.each_with_index do |path, index|
  if (match = path.match(/(.*)\/hide_lib_for_update/))
    $LOAD_PATH << "#{match[1]}/lib"
  end
end

# Require standard libraries plus Merb and Merb::Bootloader patches.

require 'appengine-rack'
require 'merb-core'

require 'lib/bootloader_patch'

# Configure and run the application. Attention: Modify the version number
# whenever you want to test the live environment without breaking the current
# release...

AppEngine::Rack.configure_app(
  # :ssl_enabled => true,
  :application => '{{name}}',
  :precompilation_enabled => true,
  :version => '1')

Merb::Config.setup(:merb_root => File.dirname(__FILE__),
                   :environment => ENV['RACK_ENV'])

Merb.environment = Merb::Config[:environment]
Merb.root = Merb::Config[:merb_root]

Merb::BootLoader.gaerun

use Merb::Rack::Static, Merb.dir_for(:public) 

run Merb::Rack::Application.new 
