# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'avalon/about/version'

Gem::Specification.new do |spec|
  spec.name          = "avalon-about"
  spec.version       = Avalon::About::VERSION
  spec.authors       = ["Michael Klein"]
  spec.email         = ["michael.klein@northwestern.edu"]
  spec.description   = %q{about_page plugins for the Avalon Media System}
  spec.summary       = %q{about_page plugins for the Avalon Media System}
  spec.homepage      = "https://github.com/avalonmediasystem/avalon-about"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "about_page"
  spec.add_dependency "mediainfo"
  
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
