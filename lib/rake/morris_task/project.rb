require 'fancy_logger'
require 'rake/morris_task/options'
require 'rake/morris_task/gemspec'
require 'rake/morris_task/project_version'
require 'rake/morris_task/assets'
require 'rake/morris_task/submodule'

module Rake
  class MorrisTask < Rake::TaskLib
    
    class Project
      attr_reader :options, :gemspec, :version, :assets, :submodule, :path, :name, :logger
      
      def initialize
        @options = Options.new(self)
        @logger  = FancyLogger.new(STDOUT)
      end
      
      def setup
        @path          = options.root
        @gemspec       = Gemspec.new(self)
        @version       = ProjectVersion.new(self, 'VERSION')
        @assets        = Assets.new(self)
        @submodule     = Submodule.new(self)
        @name          = @gemspec.basename_without_ext
      end
      
      def update
        version.update
        tag if options.tag_on_update?
      end
      
      def tag
        logger.info "Tagging as `#{version.next_version}`"
        
        run "cd #{path} && git add ."
        run "cd #{path} && git commit -m \"Version bump to #{version.next_version}\""
        run "cd #{path} && git tag #{version.next_version}"
      end
      
      def run(command, force=false)
        should_run = force || !options.fake?
        result = should_run ? `#{command}`.chomp.strip : ''
        
        message = if result.empty?
          command
        else
          command + "\n" + result.lines.collect { |line| "  => #{line}" }.join
        end
      
        logger.debug(message)
      
        result
      end
      
    end
    
  end
end
