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
          project.update
        end
      end
    end
    
    def define_default
      task :default do
        Rake::application.options.show_tasks = :tasks  # this solves sidewaysmilk problem
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



__END__

module Rake
  
  class MorrisTask < Rake::TaskLib
    
    
    def initialize
      yield(self)
      
      define
    end
    
    def root=(root)
      raise TypeError, "'root' must be a Pathname" unless root.is_a?(Pathname)
      
      @root = root
    end
    
    def fake=(value)
      @fake = !!value
    end
    
    def fake?
      @fake
    end
    
    def log_level=(level)
      logger.level = LOG_LEVELS[level] || 1
    end
    
    def tag_on_update=(value)
      @tag_on_update = !!value
    end
    
    def tag_on_update?
      @tag_on_update
    end
    
    protected
    
    def define
      raise '`root` is unset. Please set to the root directory of the project.' if @root.nil?
      
      Rake::TaskManager.record_task_metadata = true

      Gem::PackageTask.new(gemspec) do |t|
        t.need_zip = false
        t.need_tar = false
      end
      
      namespace submodule_name do
        desc 'Update the submodule'
        task :update do
          if_submodule_was_updated { submodule_checkout_latest_tag }
        end
    
        desc "Copy the `#{submodule_name}` asset files into the `vendor` folder"
        task :copy do
          if_submodule_was_updated { submodule_copy_assets }
        end
      end
      
      desc "Update `#{submodule_name}` and copy the asset files into the `vendor` folder"
      task submodule_name do
        if_submodule_was_updated do
          submodule_checkout_latest_tag
          submodule_copy_assets
        end
      end
      
      desc "Update `#{submodule_name}` then update `#{project_name}` version#{ ' and tag on git' if tag_on_update? } if `#{submodule_name}` was updated"
      task :update do
        if_submodule_was_updated do
          submodule_checkout_latest_tag
          submodule_copy_assets
          project_update
        end
      end
      
      task :default do
        Rake::application.options.show_tasks = :tasks  # this solves sidewaysmilk problem
        Rake::application.options.show_task_pattern = //
        Rake::application.display_tasks_and_comments
      end
      
    end
    
    attr_reader :root
    
    def logger
      @logger ||= FancyLogger.new(STDOUT)
    end
    
    def project_gemspec_path
      Pathname.glob( root.join('*.gemspec') ).first
    end
    
    def project_name
      project_gemspec_path.basename('.gemspec').to_s
    end
    
    def project_version_path
      root.join('VERSION')
    end
    
    def project_version
      project_version_path.read.strip rescue '0.0.0'
    end
    
    def project_path
      root.join('lib', project_name)
    end
    
    def project_assets
      Pathname.glob( assets_path.join('{javascripts,stylesheets}/*.{coffee,less}') )
    end
    
    def project_update
      project_update_version
      project_update_tag if tag_on_update?
    end
    
    def project_update_version
      logger.info "Updating `#{project_name}` to `#{submodule_latest_tag}`"
      
      project_version_path.open('w+') { |file| file.puts(submodule_latest_tag) } unless fake?
    end
    
    def project_update_tag
      logger.info "Tagging as `#{submodule_latest_tag}`"
      
      run_command "cd #{root} && git add ."
      run_command "cd #{root} && git commit -m \"Version bump to #{submodule_latest_tag}\""
      run_command "cd #{root} && git tag #{submodule_latest_tag}"
    end
    
    def assets_path
      root.join('app', 'assets')
    end
    
    def assets_path_check
      unless assets_path.exist?
        logger.warn "Creating assets path `#{assets_path}`..."
        assets_path.mkpath unless fake?
      end
    end
    
    def javascripts_path
      assets_path.join('javascripts')
    end
    
    def javascripts_path_check
      unless javascripts_path.exist?
        logger.warn "Creating assets path `#{javascripts_path}`..."
        javascripts_path.mkpath unless fake?
      end
    end
    
    def stylesheets_path
      assets_path.join('stylesheets')
    end
    
    def stylesheets_path_check
      unless stylesheets_path.exist?
        logger.warn "Creating assets path `#{stylesheets_path}`..."
        stylesheets_path.mkpath unless fake?
      end
    end
    
    def submodule_name
      project_name.gsub(/-rails$/, '')
    end
    
    def submodule_path
      @root.join('lib', submodule_name)
    end
    
    def submodule_latest_tag
      unless instance_variable_defined?(:@submodule_latest_tag)
        logger.info "Finding latest `#{submodule_name}` tag..."
        @submodule_latest_tag = run_command("cd #{submodule_path} && git describe --abbrev=0 --tags", true).strip
      end
      
      @submodule_latest_tag
    end
    
    def submodule_was_updated?
      project_version != submodule_latest_tag
    end
    
    def submodule_checkout_latest_tag
      logger.info "Updating `#{submodule_name}` to checkout tag `#{submodule_latest_tag}`"
      
      run_command "cd #{submodule_path} && git checkout #{submodule_latest_tag}"
    end
    
    def submodule_coffeescripts
      Pathname.glob( submodule_path.join('lib', '*.coffee') )
    end
    
    def submodule_stylesheets
      Pathname.glob( submodule_path.join('less', '*.less') )
    end
    
    def submodule_copy_assets
      assets_path_check
      javascripts_path_check
      stylesheets_path_check
      
      unless project_assets.empty?
        logger.info "Destroying old assets..."
        
        project_assets.each(&:delete)
      end
      
      
      logger.info "Copying assets..."
      submodule_coffeescripts.each do |path|
        run_command "cp #{path} #{javascripts_path}"
      end
      
      submodule_stylesheets.each do |path|
        run_command "cp #{path} #{stylesheets_path}"
      end
    end
    
    def if_submodule_was_updated(&block)
      message = "`#{submodule_name}` has not been updated. Current version: #{submodule_latest_tag}"
      
      submodule_was_updated? ? yield : logger.info(message)
    end
    
    def run_command(command, force=false)
      should_run = force || !fake?
      result = should_run ? `#{command}`.chomp.strip : ''
      
      message = if result.empty?
        command
      else
        command + "\n" + result.lines.collect { |line| "  => #{line}" }.join
      end
  
      logger.debug(message)
  
      result
    end
    
  end
  
end