require 'pathname'
require 'forwardable'

module Rake
  class MorrisTask < Rake::TaskLib
    
    class Base
      
      extend Forwardable
      
      attr_reader :project
      def_delegators :project, :logger
      
      def initialize(project)
        @project = project
      end
      
      protected
      
      def mkpath_if_needed
        unless path.exist?
          logger.warn "Creating path `#{path}`..."
          
          path.mkpath unless project.options.fake?
        end
      end
      
    end
    
  end
end
