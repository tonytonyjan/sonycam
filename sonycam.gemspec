$:.push File.expand_path('../lib', __FILE__)
require 'sonycam/version'

Gem::Specification.new do |s|
  s.name        = 'sonycam'
  s.version     = Sonycam::VERSION
  s.licenses    = ['MIT']
  s.summary     = 'Sony Camera Remote API Wrapper'
  s.description = 'Sony Camera Remote API Wrapper'
  s.authors     = ['Tony Jian']
  s.email       = 'tonytonyjan@gmail.com'
  s.files       = Dir['lib/**/*.rb']
  s.executables = 'sonycam'
  s.homepage    = 'https://github.com/tonytonyjan/sonycam'
  s.add_runtime_dependency 'thor'
end