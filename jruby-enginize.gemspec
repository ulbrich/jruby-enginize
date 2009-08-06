# JRuby-Enginize, a generator for Google AppEngine compliant JRuby apps.

Gem::Specification.new do |spec|
  spec.platform = "ruby"
  spec.name = "jruby-enginize"
  spec.homepage = "http://github.com/ulbrich/jruby-enginize"
  spec.version = "0.7.1"
  spec.author = "Jan Ulbrich"
  spec.email = "jan.ulbrich @nospam@ holtzbrinck.com"
  spec.summary = "A package for generating Google AppEngine compliant JRuby projects."
  spec.files = ["bin/jruby-enginize", "lib/generator.rb", "lib/script.rb", "templates/sinatra/views/stylesheet.sass", "templates/sinatra/views/layout.haml", "templates/sinatra/views/index.haml", "templates/sinatra/public/images/sinatra_logo.png", "templates/sinatra/lib/tasks/sinatra.rake", "templates/sinatra/lib/tasks/haml-2_2_2-util.patch", "templates/sinatra/config.ru", "templates/sinatra/app.rb", "templates/sinatra/.gitignore", "templates/shared/README", "templates/shared/Rakefile", "templates/shared/public/robots.txt", "templates/shared/public/images/appengine_logo.png", "templates/shared/public/favicon.ico", "templates/merb/views/layout.engine_app.html.erb", "templates/merb/views/index.html.erb", "templates/merb/spec/spec_helper.rb", "templates/merb/public/stylesheets/default.css", "templates/merb/public/images/merb_logo.png", "templates/merb/lib/tasks/merb.rake", "templates/merb/config.ru", "templates/merb/config/init.rb", "templates/merb/config/framework.rb", "templates/merb/app.rb", "templates/merb/.gitignore", "README.rdoc"]
  spec.require_path = "."
  spec.has_rdoc = true
  spec.executables = ["jruby-enginize"]
  spec.extra_rdoc_files = ["README.rdoc"]
  spec.rdoc_options = ["--exclude", "pkg", "--exclude", "templates", "--all", "--title", "JRuby-Enginize", "--main", "README.rdoc"]
end
