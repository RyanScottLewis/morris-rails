require 'rake/morris_task/base'
require 'rake/morris_task/javascripts'
require 'rake/morris_task/stylesheets'

module Rake
  class MorrisTask < Rake::TaskLib
    
    class Assets < Base
      
      def path
        project.path.join('app', 'assets')
      end
      
      def javascripts
        @javascripts ||= Javascripts.new(project)
      end
      
      def stylesheets
        @stylesheets ||= Stylesheets.new(project)
      end
      
      def files
        Pathname.glob( path.join('{javascripts,stylesheets}/*.{coffee,less}') )
      end
      
      def empty?
        files.empty?
      end
      
      def setup_if_needed
        javascripts.mkpath_if_needed
        stylesheets.mkpath_if_needed
        clean_if_needed
      end
      
      protected
      
      def clean_if_needed
        unless empty?
          logger.info "Destroying old assets..."
          
          files.each(&:delete)
        end
      end
      
    end
    
  end
end
