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

# EOF
