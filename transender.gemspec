# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{transender}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mihael"]
  s.date = %q{2009-03-23}
  s.default_executable = %q{transender}
  s.email = %q{kitschmaster@gmail.com}
  s.executables = ["transender"]
  s.extra_rdoc_files = ["README.rdoc", "README.txt", "LICENSE"]
  s.files = ["History.txt", "README.rdoc", "README.txt", "VERSION.yml", "bin/transender", "lib/tasks", "lib/tasks/pushup.rake", "lib/transender.rb", "test/test_transender.rb", "test/test_transender.sh", "spec/spec_helper.rb", "spec/transender_spec.rb", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/mihael/transender}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Use Transender whenever you need to git-clone and rename XCode iPhone SDK projects.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
