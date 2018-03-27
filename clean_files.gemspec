# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "clean_files"
  s.version = "1.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tor Erik Linnerud"]
  s.date = "2009-05-05"
  s.default_executable = "clean_files"
  s.email = "tel@jklm.no"
  s.files = `git ls-files`.split($/)
  s.executables = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.has_rdoc = true
  s.homepage = "http://github.com/alphasights/clean_files"
  s.require_paths = ["lib"]
  s.summary = "Executable to delete files which fit certain criteria"
  s.description = "Executable to delete files which fit certain criteria e.g. you can delete files older than 1 month keeping one weekly file"
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.license = 'MIT'

  s.add_development_dependency 'rspec', '~> 3'
  s.add_runtime_dependency 'activesupport', '~> 5'

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown",
  ]
end
