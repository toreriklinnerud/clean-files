# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{clean-files}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tor Erik Linnerud"]
  s.date = %q{2009-05-05}
  s.email = %q{torerik.linnerud@alphasights.com}
  s.executables = ["clean_files", "clean_files"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "bin/clean_files",
    "lib/clean_files.rb",
    "lib/cleaner.rb",
    "spec/cleaner_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/alphasights/clean-files}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Executable to delete files which fit certain criteria}
  s.test_files = [
    "spec/cleaner_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
  end
end
