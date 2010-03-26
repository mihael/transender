# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{transender}
  s.version = "0.2.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mihael"]
  s.date = %q{2010-03-26}
  s.email = %q{kitschmaster@gmail.com}
  s.executables = ["transender", "transender-rename"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitattributes",
     ".gitignore",
     ".gitmodules",
     "History.txt",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION.yml",
     "bin/transender",
     "bin/transender-rename",
     "lib/abowl/Transends/program.json",
     "lib/abowl/Transends/stage.json",
     "lib/abowl/abowl.yml",
     "lib/abowl/devlog.markdown",
     "lib/tasks/pushup.rake",
     "lib/transender.rb",
     "spec/spec_helper.rb",
     "spec/transender_spec.rb",
     "test/test_transender.rb",
     "test/test_transender.sh",
     "transender.gemspec"
  ]
  s.homepage = %q{http://github.com/mihael/transender}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{transender}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Use Transender whenever you need to git-clone and rename XCode iPhone SDK projects.}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/transender_spec.rb",
     "test/test_transender.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
