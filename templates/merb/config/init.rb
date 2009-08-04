# Go to http://wiki.merbivore.com/pages/init-rb

#  use_orm :none
use_test :rspec
use_template_engine :erb

# Specify a specific version of a dependency
# dependency "RedCloth", "> 3.0"

Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
end

# Move this to app.rb if you want it to be reloadable in dev mode.
Merb::Router.prepare do
  match('/').to(:controller => 'engine_app', :action =>'index')

  default_routes
end

Merb::Config.use { |c|
  c[:environment]         = 'production',
  c[:framework]           = {},
  c[:log_level]           = :debug,
  c[:log_stream]          = STDOUT,
  c[:use_mutex]           = false,
  c[:session_store]       = 'cookie',
  c[:session_id_key]      = '_{{name}}_session_id',
  c[:session_secret_key]  = '{{hexrand-41}}',
  c[:exception_details]   = false,
  c[:reload_classes]      = false,
  c[:reload_templates]    = false
}
