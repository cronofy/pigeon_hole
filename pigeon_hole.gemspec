Gem::Specification.new do |s|
  s.name     = "pigeon_hole"
  s.version  = "0.1.2"
  s.platform = Gem::Platform::RUBY
  s.summary  = "Opt-in typed serialization for complex JSON types"
  s.homepage = "https://github.com/cronofy/pigeon_hole"
  s.authors  = ['Stephen Binns']
  s.license  = 'MIT'

  s.files         = Dir["lib/**/*"]
  s.test_files    = Dir["spec/**/*"]
  s.require_paths = ["lib"]
end
