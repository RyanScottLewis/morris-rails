require 'rake/morris_task/base'

module Rake
  class MorrisTask < Rake::TaskLib
    
    class Version < Base
      
      def path
        project.path.join('VERSION')
      end
      
      def update
        logger.info "Updating `#{project.name}` to `#{project.submodule.latest_tag}`"
      
        path.open('w+') { |file| file.puts(project.submodule.latest_tag) } unless project.options.fake?
      end
      
      def to_s
        @value ||= (path.read.strip rescue '0.0.0')
      end
      
      def ==(other)
        to_s == other
      end
      
    end
    
  end
end
