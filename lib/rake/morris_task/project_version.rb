require 'rake/morris_task/version'

module Rake
  class MorrisTask < Rake::TaskLib
    
    class ProjectVersion < Version
      
      protected
      
      def new_version
        version = to_a
        version[2] += 1
        
        version.join(?.)
      end
      
    end
    
  end
end
