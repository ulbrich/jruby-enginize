# This application files as generated by jruby-enginize.

require 'rubygems'

begin
  require 'haml'
  require 'sass'

  require 'sinatra'
rescue LoadError => exception
end

# Helpers to include...

helpers do
  include Rack::Utils

  alias_method :h, :escape_html
end

# GET /
 
get '/' do
  haml :index
end

# GET /stylesheet.css

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'

  sass :stylesheet
end
