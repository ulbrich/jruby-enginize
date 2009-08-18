# Task for loading gems needed by this template. Bootstrap to get installed...

namespace :template do
  desc 'Load missing gems to local gem repository'
  task :gems do
    appcfg = which_executable('appcfg.rb')
    patch = which_executable('patch')

    puts 'Load missing gems to local gem repository'
    `(sudo #{appcfg} gem install appengine-apis haml sinatra) 1>&2`
    puts 'Add patch for Haml 2.2.2 if needed'
    `(sudo #{patch} --batch --silent .gems/gems/haml-2.2.2/lib/haml/util.rb < lib/tasks/haml-2_2_2-util.patch) 2> /dev/null 1>&2`
  end
end

# Add your own tasks...

namespace :sinatra do
end
