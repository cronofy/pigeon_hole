Gem::Specification.new do |s|
  s.name     = "pigeonhole"
  s.version  = "0.0.1"
  s.platform = Gem::Platform::RUBY
  s.summary  = "Opt-in typed serialization for complex JSON types"
  s.homepage = "http://www.cronofy.com"
  s.authors  = ['Stephen Binns']
  s.license  = 'MIT'

  s.files         = Dir["lib/**/*"]
  s.test_files    = Dir["spec/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency('json')
end
