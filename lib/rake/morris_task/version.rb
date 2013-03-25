require 'rake/morris_task/base'

module Rake
  class MorrisTask < Rake::TaskLib
    
    class Version < Base
      
      attr_reader :name
      
      def initialize(project, name)
        @project, @name = project, name
      end
      
      def path
        project.path.join(name)
      end
      
      def update
        content = new_version
        logger.info "Updating `#{ path.basename }` to `#{content}`"
        
        path.open('w+') { |file| file.puts(content) } unless project.options.fake?
      end
      
      def to_s
        @value ||= (path.read.strip rescue '0.0.0')
      end
      
      def to_a
        to_s.split(?.).collect(&:to_i)
      end
      
      def ==(other)
        to_s == other
      end
      
      protected
      
      def new_version
        raise NotImplementedError
      end
      
    end
    
  end
end
