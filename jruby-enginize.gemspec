# JRuby-Enginize, a generator for Google AppEngine compliant JRuby apps.

require 'find'

Gem::Specification.new do |spec|
  template_files = []

  Find.find('templates') { |path|
    template_files << path if not File.stat(path).directory? }

  spec.platform = Gem::Platform::RUBY
  spec.name = 'jruby-enginize'
  spec.homepage = 'http://github.com/ulbrich/jruby-enginize'
  spec.version = '0.1'
  spec.author = 'Jan Ulbrich'
  spec.email = 'jan.ulbrich @nospam@ holtzbrinck.com'
  spec.summary = 'A package for generating Google AppEngine compliant JRuby projects.'
  spec.files = FileList['bin/*', 'lib/*.rb', 'tests/*.rb'].to_a + template_files
  spec.require_path = '.'
  spec.test_files = Dir.glob('tests/*.rb')
  spec.has_rdoc = true
  spec.executables = ['jruby-enginize']
  spec.extra_rdoc_files = ['README']
  spec.rdoc_options << '--exclude' << 'pkg' << '--exclude' << 'templates' <<
    '--all' << '--title' << 'JRuby-Enginize' << '--main' << 'README'
end
