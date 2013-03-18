require 'rake/morris_task/base'

module Rake
  class MorrisTask < Rake::TaskLib
    
    class Stylesheets < Base
      
      def path
        project.assets.path.join('stylesheets')
      end
      
    end
    
  end
end
