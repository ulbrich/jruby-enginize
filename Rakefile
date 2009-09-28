# JRuby-Enginize, a generator for Google AppEngine compliant JRuby apps.

require 'rubygems'
require 'rake/gempackagetask'

require 'find'

spec = Gem::Specification.new do |spec|
  template_files = []

  Find.find('templates') { |path|
    template_files << path if not File.stat(path).directory? }

  files = FileList['bin/*', 'lib/*.rb', 'tests/*.rb'].to_a + template_files

  spec.platform = Gem::Platform::RUBY
  spec.name = 'jruby-enginize'
  spec.homepage = 'http://github.com/ulbrich/jruby-enginize'
  spec.version = '0.7.3'
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

desc 'Create rdoc documentation from the code'
task :doc do
  `rm -rf doc`

  puts 'Create rdoc documentation from the code'
  puts `(rdoc --include bin/jruby-enginize --exclude pkg --exclude templates \
          --all --title "JRuby-Enginize" README.rdoc lib) 1>&2`
end

desc 'Update the jruby-enginize.gemspec file with new snapshot of files to bundle'
task :gemspecs do
  puts 'Update the jruby-enginize.gemspec file with new snapshot of files to bundle.'

  # !!Warning: We can't use spec.to_ruby as this generates executable code
  # which would break Github gem generation...

  template = <<EOF
# JRuby-Enginize, a generator for Google AppEngine compliant JRuby apps.

Gem::Specification.new do |spec|
  spec.platform = #{spec.platform.inspect}
  spec.name = #{spec.name.inspect}
  spec.homepage = #{spec.homepage.inspect}
  spec.version = "#{spec.version}"
  spec.author = #{spec.author.inspect}
  spec.email = #{spec.email.inspect}
  spec.summary = #{spec.summary.inspect}
  spec.files = #{spec.files.inspect}
  spec.require_path = #{spec.require_path.inspect}
  spec.has_rdoc = #{spec.has_rdoc}
  spec.executables = #{spec.executables.inspect}
  spec.extra_rdoc_files = #{spec.extra_rdoc_files.inspect}
  spec.rdoc_options = #{spec.rdoc_options.inspect}
end
EOF

  File.open('jruby-enginize.gemspec', 'w').write(template)
end
