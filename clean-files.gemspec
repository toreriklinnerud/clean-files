# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name                      = %q{clean-files}
  s.version                   = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors                   = ["Tor Erik Linnerud"]
  s.date                      = %q{2009-05-05}
  s.default_executable        = %q{clean_files}
  s.email                     = %q{torerik.linnerud@alphasights.com}
  s.executables               = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files                = s.files.grep(%r{^(test|spec|features)/})
  s.files                     = `git ls-files`.split($/)
  s.has_rdoc                  = true
  s.homepage                  = %q{http://github.com/alphasights/clean-files}
  s.require_paths             = ["lib"]
  s.summary                   = %q{Executable to delete files which fit certain criteria}
  s.test_files                = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency 'rake'
  s.add_dependency 'rspec'
  s.add_dependency 'rdoc'
  s.add_dependency 'activesupport'

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
end
