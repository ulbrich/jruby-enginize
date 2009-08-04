# Tasks provided by Merb are guarded with a rescue block as we need this file
# to work prior to installation of Merb.

begin
  require 'merb-core'
  require 'merb-core/tasks/merb'

  include FileUtils

  # Load the basic runtime dependencies; this will include 
  # any plugins and therefore plugin rake tasks.
  init_env = ENV['MERB_ENV'] || 'rake'
  Merb.load_dependencies(:environment => init_env)
     
  # Get Merb plugins and dependencies
  Merb::Plugins.rakefiles.each { |r| require r } 

  # Load any app level custom rakefile extensions from lib/tasks
  tasks_path = File.join(File.dirname(__FILE__), "lib", "tasks")
  rake_files = Dir["#{tasks_path}/*.rake"]
  rake_files.each{|rake_file| load rake_file }

  require 'spec/rake/spectask'
  require 'merb-core/test/tasks/spectasks'
rescue Exception
end

# Task for loading gems needed by this template. Bootstrap to get installed...

namespace :template do
  desc 'Load missing gems to local gem repository'
  task :gems do
    puts 'Load missing gems to local gem repository'
    `(sudo appcfg.rb gem install extlib merb-core) 1>&2`
  end
end

# Add your own tasks...

namespace :merb do
end

