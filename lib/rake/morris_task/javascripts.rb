require 'rake/morris_task/base'

module Rake
  class MorrisTask < Rake::TaskLib
    
    class Javascripts < Base
      
      def path
        project.assets.path.join('javascripts')
      end
      
    end
    
  end
end
