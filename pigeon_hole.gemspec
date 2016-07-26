Gem::Specification.new do |s|
  s.name     = "pigeon_hole"
  s.version  = "0.0.4"
  s.platform = Gem::Platform::RUBY
  s.summary  = "Opt-in typed serialization for complex JSON types"
  s.homepage = "http://www.cronofy.com"
  s.authors  = ['Stephen Binns']
  s.license  = 'MIT'

  s.files         = Dir["lib/**/*"]
  s.test_files    = Dir["spec/**/*"]
  s.require_paths = ["lib"]
end
