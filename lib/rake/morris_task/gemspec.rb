require 'rake/morris_task/base'
require 'rubygems/specification'

module Rake
  class MorrisTask < Rake::TaskLib
    
    class Gemspec < Base
      
      def path
        Pathname.glob( project.path.join('*.gemspec') ).first
      end
      
      def basename_without_ext
        path.basename('.gemspec').to_s
      end
      
      def load
        Gem::Specification.load(path.to_s)
      end
      
    end
    
  end
end
