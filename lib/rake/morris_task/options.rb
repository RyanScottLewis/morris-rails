require 'rake/morris_task/base'

module Rake
  class MorrisTask < Rake::TaskLib
    
    class Options < Base
    
      LOG_LEVELS = {
        debug:   0,
        info:    1,
        warn:    2,
        error:   3,
        fatal:   4,
        unknown: 5
      }
    
      attr_reader :root, :log_level
    
      def root=(root)
        raise TypeError, "'root' must be a Pathname" unless root.is_a?(Pathname)
      
        @root = root
      end
      
      def fake=(value)
        @fake = !!value
      end
    
      def fake?
        @fake
      end
    
      def log_level=(level)
        logger.level = LOG_LEVELS[level] || 1
      end
    
      def tag_on_update=(value)
        @tag_on_update = !!value
      end
    
      def tag_on_update?
        @tag_on_update
      end
    
    end
    
  end
end
