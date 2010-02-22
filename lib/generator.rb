# JRuby-Enginize, a generator for Google AppEngine compliant JRuby apps.
#
# This file contains the JRubyEnginize::Generator class creating a new
# directory tree of files drawn from a set of shared and specific templates.

require 'ftools'
require 'find'
require 'digest/md5'

module JRubyEnginize # :nodoc:

  # Code for generating a directory tree created from a shared and a template
  # specific set of template files.

  class Generator
    attr_reader :email, :template, :name, :path, :dryrun

    # Constructor of the generator needing at least email, path and template
    # to run.
    #
    # Parameters:
    #
    # [email] Mail address of the Google AppEngine account to publish with
    # [path] Path of the directory to create
    # [template] Name of the set of templates to generate from
    # [options] Additional options
    #
    # Options:
    # 
    # [:name] Optional app name defaulting to name of directory
    # [:dryrun] Flag to enable 

    def initialize(email, path, template, options = {})
      @email = email
      @path = path
      @template = template

      options = options.dup

      @name = options.delete(:name)
      @name = File.basename(path) if @name.nil? or @name.empty?

      @dryrun = options.delete(:dryrun)

      raise ArgumentError, "Unknown option(s) #{options.keys.join(', ')}" unless options.empty?
    end

    # Runs the generator. Starts with setting up a map of files to create
    # and overriding shared ones with template specific stuff. Runs through
    # the collected files and calls process_file to render new files in the
    # target path.

    def run
      templatesdir = Generator::templates_directory

      shareddir = File.join(templatesdir, 'shared')
      templatedir = File.join(templatesdir, template)

      raise ArgumentError, 'Missing shared templates' unless File.stat(shareddir).directory?
      raise ArgumentError, "Template \"#{template}\" missing" unless File.stat(templatedir).directory?

      if dryrun
        puts "Dry run which would generate the following files from template \"#{template}\":"
      else
        puts "Generating files from template \"#{template}\"."
      end

      template_files(shareddir, templatedir).each do |key, path|
        target = File.join(self.path, key)

        if dryrun
          puts "  Creating \"#{target}\" from template\n    file \"#{path}\""
        else
          process_file(path, target)
        end
      end
      
      if not dryrun
        puts "Done with directory \"#{self.path}\"."

        puts "\nYour next steps:\n  cd #{self.path}\n\n  rake\n  rake --tasks"
        puts "\n  rake appengine:run"
        puts "\n  rake appengine:deploy"
      end
    end

    # Returns an Array with the available template names.

    def self.templates
      return Dir[File.join(Generator::templates_directory, '*')].collect { |path|
               (name = File.basename(path)) == 'shared' ? nil : name }.compact
    end      

    protected

      # Returns a Hash with relative paths of files as keys and the whole
      # paths as values. Runs through all paths in the order as provided and
      # overrides keys with files found in later paths.
      #
      # Sample:
      #
      #   + templates
      #      + shared
      #      |  + foo
      #      |  + lib
      #      |     + bar # Will be overridden with file found in specific
      #      |
      #      + specific
      #         + lib
      #         |  + bar
      #         |
      #         + other
      #
      #   => { 'foo' => '/path/templates/shared/foo',
      #      'lib/bar' => '/path/templates/specific/bar',
      #      'other' => '/path/templates/specific/other' }
      #
      # Parameters:
      #
      # [*paths] Paths to directories to gather files from

      def template_files(*paths)
        files = {}

        Find.find(*paths) do |path|
          Find.prune if path[-1].chr == '.'

          next if File.stat(path).directory?
          next if (key = path.gsub(/.*\/templates\/[^\/]+\//, '')) == ''

          files[key] = path
        end

        return files
      end      

      # Creates the target file from the source including some substitution
      # of variables. The target path needs not to exist, as directories are
      # added on the fly. If the source is an executable, the target file will
      # be set executable, too.
      #
      # Parameters:
      #
      # [source] Source file
      # [target] Target file
      #
      # The source files may contain some variables which are replaced on the
      # fly. All variables are set in double curly brackets and are let passed
      # without modification if they ar not recognized.
      #
      # Supported variables:
      #
      # [{{email}}] E-mail address of the Google AppEngine account
      # [{{name}}] Name of the application
      # [{{template}}] Name of the template (e.g. "sinatra")
      # [{{hexrand-xx}}] Hexadecimal random string with xx characters
      # [{{numrand-xx}}] Random number with xx digits

      def process_file(source, target)
        content = File.read(source).gsub(/\{\{[^}]*\}\}/) do |variable|
          case variable
          when '{{email}}'
            raise 'missing e-mail address' if email.nil? or email.empty?
            email
          when '{{name}}'
            name
          else
            if hexrand = variable.match(/\{\{hexrand-([0-9]+)\}\}/) and
              hexrand.length == 2 and (len = hexrand[1].to_i) > 0
            then
              str = ''

              while str.length < len do
                str << Digest::MD5.hexdigest("#{rand}-#{Time.now}-#{rand}")
              end

              str[0, len]
            elsif numrand = variable.match(/\{\{numrand-([0-9]+)\}\}/) and
              numrand.length == 2 and (len = numrand[1].to_i) > 0
            then
              str = ''

              while str.length < len do
                str << rand.to_s.sub(/^.*\.0*/, '')
              end

              str[0, len]
            else
              variable
            end
          end
        end

        File.makedirs(File.dirname(target))

        File.open(target, 'wb') do |file|
          stat = File.stat(source)

          file.write(content)
          file.chmod(stat.mode | 0x111) if stat.executable?
        end
      end

      # Returns the directory where the template files reside (located
      # relative to the source file of class JRubyEnginize::Generator).

      def self.templates_directory
        return File.join(File.dirname(File.dirname(__FILE__)), 'templates')
      end
  end
end
