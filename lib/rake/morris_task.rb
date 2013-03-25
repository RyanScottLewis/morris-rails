require 'rake/tasklib'
require 'rubygems/package_task'
require 'rake/morris_task/project'

module Rake
  
  class MorrisTask < Rake::TaskLib
    
    attr_reader :project
    
    def initialize
      @project = Project.new
      
      yield(project.options)
      raise '`root` is unset. Please set to the root directory of the project.' if project.options.root.nil?
      project.setup
      Rake::TaskManager.record_task_metadata = true
      
      define
    end
    
    protected
    
    def define
      define_package
      define_submodule
      define_update
      define_default
    end
    
    def define_package
      Gem::PackageTask.new(project.gemspec.load) do |t|
        t.need_zip = false
        t.need_tar = false
      end
    end
    
    def define_submodule_update
      namespace project.submodule.name do
        desc 'Update the submodule'
        task :update do
          if_submodule_was_updated { project.submodule.checkout_latest_tag }
        end
      end
    end
    
    def define_submodule_copy
      namespace project.submodule.name do
        desc "Copy the `#{project.submodule.name}` asset files into the `vendor` folder"
        task :copy do
          if_submodule_was_updated { project.submodule.copy_assets }
        end
      end
    end
    
    def define_submodule_default
      desc "Update `#{project.submodule.name}` and copy the asset files into the `vendor` folder"
      task project.submodule.name do
        if_submodule_was_updated do
          project.submodule.checkout_latest_tag
          project.submodule.copy_assets
          project.assets.version.update
        end
      end
    end
    
    def define_submodule
      define_submodule_update
      define_submodule_copy
      define_submodule_default
    end
    
    def define_update
      desc "Update `#{project.submodule.name}` then update `#{project.name}` version#{ ' and tag on git' if project.options.tag_on_update? } if `#{project.submodule.name}` was updated"
      task :update do
        if_submodule_was_updated do
          project.submodule.checkout_latest_tag
          project.submodule.copy_assets
          project.assets.version.update
        end
        
        project.update
      end
    end
    
    def define_default
      task :default do
        Rake::application.options.show_tasks = :tasks
        Rake::application.options.show_task_pattern = //
        Rake::application.display_tasks_and_comments
      end
    end
    
    def if_submodule_was_updated(&block)
      message = "`#{project.submodule.name}` has not been updated. Current version: #{project.submodule.latest_tag}"
      
      project.submodule.updated? ? yield : project.logger.info(message)
    end
    
  end
  
end
