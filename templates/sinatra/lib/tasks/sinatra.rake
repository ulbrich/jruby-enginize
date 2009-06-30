namespace :sinatra do
  desc 'Start a local test server on part 4567'
  task :run do
    puts 'Start a local test server on part 4567'
    puts `jruby -S app.rb`
  end
end
