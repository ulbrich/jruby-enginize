# JRuby-Enginize, a generator for Google AppEngine compliant JRuby apps.
#
# This file contains the JRubyEnginize::Generator class creating a new
# directory tree of files drawn from a set of shared and specific templates.

require 'ftools'
require 'find'

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

      
      puts "!!no changes written as this is only a dry run...\n" if dryrun
      puts "Generating files for template \"#{template}\":\n\n"

      template_files(shareddir, templatedir).each do |key, path|
        target = File.join(self.path, key)
        puts "  Creating \"#{target}\" from template\n    file \"#{path}\""

        process_file(path, target) unless dryrun
      end
      
      puts "\nYour next steps:\n\n  cd #{self.path}\n\n  jruby -S rake"
      puts "  jruby -S rake --tasks\n\n  jruby -S rake appengine:deploy\n\n"
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

      def process_file(source, target)
        content = File.read(source).gsub(/\{\{[^}]*\}\}/) do |match|
          case match
          when '{{email}}'
            email
          when '{{name}}'
            name
          else
            match
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
