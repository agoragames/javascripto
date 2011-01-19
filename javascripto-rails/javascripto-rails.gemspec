# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "javascripto-rails/version"

Gem::Specification.new do |s|
  s.name        = "javascripto-rails"
  s.version     = Javascripto::Rails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Blake Taylor"]
  s.email       = ["btaylor@agoragames.com"]
  s.homepage    = "http://javascripto.org"
  s.summary     = %q{Rails plugin gem for Javascripto Client-side Application Framework.}
  # s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "javascripto-rails"

  s.add_runtime_dependency "javascripto", ">= 0.0.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
