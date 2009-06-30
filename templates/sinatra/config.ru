require 'rubygems'
require 'sinatra'
 
root_dir = File.dirname(__FILE__)
 
set :environment, :production
set :root, root_dir
set :app_file, File.join(root_dir, 'app.rb')
disable :run
 
require 'app'
 
run Sinatra::Application
