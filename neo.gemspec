lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "neo/version"

Gem::Specification.new do |s|
  s.name        = 'neo'
  s.version     = '1.0.0'
  s.date        = '2019-04-09'
  s.summary     = "This gem provides a simple wrapper for https://api.nasa.gov/api.html#NeoWS API"
  s.description = "Retrieve information about the closest near earth object using the NASA NEO API. "
  s.authors     = ["Jimmy Sutherland"]
  s.email       = 'jrsutherland78@googlemail.com'
  s.homepage    = 'https://github.com/LondonJim/NASA-NEO-API-Wrapper'
  s.license     = 'MIT'

  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  s.bindir        = 'exe'
  s.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.17'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'webmock', '~> 3.5.1'
end
