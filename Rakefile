# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'transender'

task :default => 'spec:run'

PROJ.name = 'transender'
PROJ.authors = 'Mihael'
PROJ.email = 'kitschmaster@gmail.com'
PROJ.url = 'http://kitschmaster.com/kiches/246'
PROJ.version = Transender::VERSION
PROJ.rubyforge.name = 'transender'
PROJ.spec.opts << '--color'
PROJ.ignore_file = '.gitignore'
PROJ.readme_file = 'README.txt'

require 'rubygems'
require 'rake'
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "transender"
    gem.summary = %Q{Use Transender whenever you need to git-clone and rename XCode iPhone SDK projects.}
    gem.email = "kitschmaster@gmail.com"
    gem.homepage = "http://github.com/mihael/transender"
    gem.authors = ["Mihael"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'transender'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end
