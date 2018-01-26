lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flaggy/version'

Gem::Specification.new do |spec|
  spec.name     = 'flaggy'
  spec.version  = Flaggy::VERSION
  spec.authors  = ['Karol Słuszniak']
  spec.email    = 'karol@shedul.com'
  spec.homepage = 'http://github.com/surgeventures/flaggy-ruby'
  spec.license  = 'MIT'
  spec.platform = Gem::Platform::RUBY

  spec.summary = 'Multi-source Ruby client for managing feature flags'

  spec.files            = Dir["lib/**/*.rb"]
  spec.has_rdoc         = false
  spec.extra_rdoc_files = ["README.md"]
  spec.test_files       = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths    = ["lib"]

  spec.add_runtime_dependency 'concurrent-ruby', '>= 1.0.0'
end
