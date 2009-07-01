namespace :sinatra do
  desc 'Start a local test server on part 4567'
  task :run do
    puts 'Start a local test server on part 4567'
    `(jruby -S app.rb) 1>&2`
  end
end
