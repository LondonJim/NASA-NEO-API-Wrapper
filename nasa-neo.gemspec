lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nasa-neo/version"

Gem::Specification.new do |s|
  s.name        = 'nasa-neo'
  s.version     = '1.0.3'
  s.date        = '2019-04-09'
  s.summary     = "This gem provides a simple wrapper for https://api.nasa.gov/api.html#NeoWS API"
  s.description = "Retrieve information about the closest near earth object on any given day using the NASA NEO API. "
  s.authors     = ["James Sutherland"]
  s.email       = 'jrsutherland78@googlemail.com'
  s.homepage    = 'https://github.com/LondonJim/NASA-NEO-API-Wrapper'
  s.license     = 'MIT'

  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  s.bindir        = 'bin'
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 2.0.1'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'webmock', '~> 3.5.1'
end
