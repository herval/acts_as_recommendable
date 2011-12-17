# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "acts_as_recommendable"
  s.version     = '0.0.1'
  s.authors     = ["macman"]
  s.email       = %q{info@eribium.org}
  s.homepage    = %q{https://github.com/maccman/acts_as_recommendable}
  s.summary     = %q{Recommendation engine for Rails}
  s.description = %q{A recommendation engine for Rails.}

  s.add_dependency             'rails', '>= 3.0.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'sdoc'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'ruby-debug-completion'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
