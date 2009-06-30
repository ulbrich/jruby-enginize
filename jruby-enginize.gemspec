# JRuby-Enginize, a generator for Google AppEngine compliant JRuby apps.

Gem::Specification.new do |spec|
  files = ["bin/jruby-enginize", "lib/generator.rb", "lib/script.rb", "templates/sinatra/views/stylesheet.sass", "templates/sinatra/views/layout.haml", "templates/sinatra/views/index.haml", "templates/sinatra/public/images/sinatra_logo.png", "templates/sinatra/lib/tasks/sinatra.rake", "templates/sinatra/config.ru", "templates/sinatra/config/warble.rb", "templates/sinatra/app.rb", "templates/shared/README", "templates/shared/Rakefile", "templates/shared/public/images/appengine_logo.png", "templates/shared/lib/split-jruby.sh", "templates/shared/lib/jruby-rack-0.9.4.jar", "templates/shared/appengine-web.xml"]

  spec.platform = Gem::Platform::RUBY
  spec.name = 'jruby-enginize'
  spec.homepage = 'http://github.com/ulbrich/jruby-enginize'
  spec.version = '0.3'
  spec.author = 'Jan Ulbrich'
  spec.email = 'jan.ulbrich @nospam@ holtzbrinck.com'
  spec.summary = 'A package for generating Google AppEngine compliant JRuby projects.'
  spec.files = files
  spec.require_path = '.'
  spec.has_rdoc = true
  spec.executables = ['jruby-enginize']
  spec.extra_rdoc_files = ['README.rdoc']
  spec.rdoc_options << '--exclude' << 'pkg' << '--exclude' << 'templates' <<
    '--all' << '--title' << 'JRuby-Enginize' << '--main' << 'README.rdoc'
end
