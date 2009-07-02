# JRuby-Enginize, a generator for Google AppEngine compliant JRuby apps.
#
# This file contains the JRubyEnginize::Script class refactored to keep the
# executables lean.

require 'optparse'
require 'rubygems'

require 'lib/generator'

module JRubyEnginize # :nodoc:

  # Commandline code refactored to keep the executables lean.

  module Script
    
    # Command line code for the <tt>"jruby-enginize"</tt> executable. Call
    # with <tt>"--help"</tt> to learn more. Checks for running on JRuby and
    # having the Google AppEngine SDK around and forwards work to
    # JRubyEnginize::Generator.

    def self.enginize
      email = nil
      template = 'sinatra'
      path = nil

      prog = File.basename($0)

      # Check for running with JRuby: The whole generator makes no sense if not 
      # running with or at least for JRuby...

      begin
        java.lang.String
      rescue
        $stderr.puts "!!#{prog} makes only sense on JRuby systems. Please try again." 
        exit(1)
      end

      # The AppEngine SDK has to be around, too.

      begin
        raise ArgumentError if not File.stat(`which appcfg.sh`.chop).executable?
      rescue Exception
        $stderr.puts "!!AppEngine SDK missing. Please retry after installing." 
        exit(2)
      end

      options = { :name => nil, :dryrun => false }

      OptionParser.new do |opt|
        opt.banner = "Usage: #{prog} [options] --email address dirname"

        opt.on('-e', '--email address', 'E-Mail address to publish app with') { |email| }
        opt.on('-t', '--template name', "Name of the template (defaults to #{template})") { |template| }
        opt.on('-n', '--name appname', 'Name of the app (defaults to dir basename)') { |name|
          options[:name] = name }
        opt.on('-d', '--dry', 'Test run not really creating files') {
          options[:dryrun] = true }
        opt.on('-T', '--templates', 'List available templates') {
          puts 'Supported templates:'
          JRubyEnginize::Generator.templates.each { |name| puts "  #{name}" }
          exit(0) }

        begin
          opt.parse!(ARGV)

          raise 'missing directory name' if (path = ARGV.first).nil? or path.empty?
          raise 'directory already exists' if FileTest.exists? path
          raise 'unknown template' if not JRubyEnginize::Generator.templates.include? template

          raise 'missing e-mail address' if email.nil? or email.empty?
        rescue SystemExit
          exit(1)
        rescue Exception => exception
          $stderr.puts "!!#{exception}\n\n"

          opt.parse!(['--help'])

          exit(3)
        end
      end
      
      JRubyEnginize::Generator.new(email, path, template, options).run
    end
  end
end
