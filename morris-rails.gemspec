require 'pathname'

Gem::Specification.new do |s|
  
  # Variables
  s.author      = 'Ryan Scott Lewis'
  s.email       = 'ryan@rynet.us'
  s.summary     = 'morris.js for the Rails asset pipeline.'
  s.license     = 'MIT'
  
  # Dependencies
  s.add_dependency 'version',          '~> 1.0'
  s.add_dependency 'rails',            '~> 3.0'
  s.add_dependency 'jquery-rails',     '~> 2.0'
  s.add_dependency 'raphaeljs-rails',  '~> 1.0'
  s.add_dependency 'less-rails',       '~> 2.0'
  s.add_dependency 'coffee-rails',     '~> 3.0'
  s.add_development_dependency 'rake',           '~> 10.0'
  s.add_development_dependency 'fancy_logger',   '~> 0.1'
  s.add_development_dependency 'rspec',          '~> 2.13'
  s.add_development_dependency 'fuubar',         '~> 1.1'
  s.add_development_dependency 'sqlite3',        '~> 1.3'
  s.add_development_dependency 'execjs',         '~> 1.4'
  s.add_development_dependency 'therubyracer',   '~> 0.11'
  s.add_development_dependency 'rspec-rails',    '~> 2.13'
  
  # Pragmatically set variables
  s.homepage      = "http://github.com/RyanScottLewis/#{s.name}"
  s.version       = Pathname.glob('VERSION*').first.read rescue '0.0.0'
  s.description   = s.summary
  s.name          = Pathname.new(__FILE__).basename('.gemspec').to_s
  s.require_paths = ['lib']
  s.files         = Dir['{{Rake,Gem}file{.lock,},README*,VERSION,LICENSE,*.gemspec,lib/morris-rails{.rb,**/*.rb},spec/**/*.rb,app/**/*.*}']
  s.test_files    = Dir['{examples,spec,test}/**/*']
  
end
