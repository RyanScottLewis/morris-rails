require 'rake/morris_task/base'

module Rake
  class MorrisTask < Rake::TaskLib
    
    class Submodule < Base
      
      def path
        project.path.join('lib', name)
      end
      
      def name
        project.name.gsub(/-rails$/, '')
      end
      
      def latest_tag
        unless instance_variable_defined?(:@latest_tag)
          logger.info "Finding latest `#{name}` tag..."
          
          @latest_tag = project.run("cd #{path} && git describe --abbrev=0 --tags", true).strip
        end
        
        @latest_tag
      end
      
      def updated?
        project.assets.version != latest_tag
      end
      
      def checkout_latest_tag
        logger.info "Updating `#{name}` to checkout tag `#{latest_tag}`"
        
        project.run "cd #{path} && git checkout #{latest_tag}"
      end
      
      def coffeescripts
        Pathname.glob( path.join('lib', '*.coffee') )
      end
      
      def stylesheets
        Pathname.glob( path.join('less', '*.less') )
      end
      
      def copy_assets
        project.assets.setup_if_needed
        
        logger.info "Copying assets..."
        coffeescripts.each do |coffeescript_path|
          project.run "cp #{coffeescript_path} #{project.assets.javascripts.path}"
        end
        
        stylesheets.each do |stylesheet_path|
          project.run "cp #{stylesheet_path} #{project.assets.stylesheets.path}"
        end
      end
      
    end
    
  end
end
