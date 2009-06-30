# JRuby-Enginize, a generator for Google AppEngine compliant JRuby apps.

require 'rubygems'
require 'rake/gempackagetask'

require 'find'

spec = Gem::Specification.new do |spec|
  template_files = []

  Find.find('templates') { |path|
    template_files << path if not File.stat(path).directory? }

  files = FileList['bin/*', 'lib/*.rb', 'tests/*.rb'].to_a + template_files

  puts 'Files for updating specs file "jruby-enginize.gemspec":'
  p files
  puts

  spec.platform = Gem::Platform::RUBY
  spec.name = 'jruby-enginize'
  spec.homepage = 'http://github.com/ulbrich/jruby-enginize'
  spec.version = '0.3'
  spec.author = 'Jan Ulbrich'
  spec.email = 'jan.ulbrich @nospam@ holtzbrinck.com'
  spec.summary = 'A package for generating Google AppEngine compliant JRuby projects.'
  spec.files = files
  spec.require_path = '.'
  spec.test_files = Dir.glob('tests/*.rb')
  spec.has_rdoc = true
  spec.executables = ['jruby-enginize']
  spec.extra_rdoc_files = ['README.rdoc']
  spec.rdoc_options << '--exclude' << 'pkg' << '--exclude' << 'templates' <<
    '--all' << '--title' << 'JRuby-Enginize' << '--main' << 'README.rdoc'
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
  puts 'Generated latest version.'
end

desc 'Remove directories "pkg" and "doc"'
task :clean do
  puts 'Remove directories "pkg" and "doc".'
  `rm -rf pkg doc`
end

desc 'Creates rdoc documentation from the code'
task :doc do
  `rm -rf doc`

  `rdoc --include bin/jruby-enginize --exclude pkg --exclude templates \
    --all --title "JRuby-Enginize" README.rdoc lib`
end
