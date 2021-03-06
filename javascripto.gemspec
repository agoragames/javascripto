# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "javascripto/version"

Gem::Specification.new do |s|
  s.name        = "javascripto"
  s.version     = Javascripto::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Blake Taylor"]
  s.email       = ["btaylor@agoragames.com"]
  s.homepage    = "http://javascripto.org"
  s.summary     = %q{Client-side Javascript Application Framework}
  # s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "javascripto"

  s.add_development_dependency "rspec"
  s.add_development_dependency "cucumber"

  s.files         = `git ls-files | grep javascripto-rails -v`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
