# Implement task for loading gems needed by this template.

namespace :template do
  desc 'Load missing gems to local gem repository'
  task :gems do
    puts 'Load missing gems to local gem repository'
    `(sudo appcfg.rb gem install jruby-openssl haml sinatra) 1>&2`
  end
end

# Add your own tasks...

namespace :sinatra do
end
