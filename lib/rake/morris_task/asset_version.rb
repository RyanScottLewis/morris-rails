require 'rake/morris_task/version'

module Rake
  class MorrisTask < Rake::TaskLib
    
    class AssetVersion < Version
      
      protected
      
      def new_version
        project.submodule.latest_tag
      end
      
    end
    
  end
end
