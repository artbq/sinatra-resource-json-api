# encoding UTF-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sinatra/resource_json_api/version"

Gem::Specification.new do |spec|
  spec.name = "sinatra-resource-json-api"
  spec.version = Sinatra::ResourceJsonApi::VERSION
  spec.authors = ["Artem Tseranu"]
  spec.email = ["artbqts@gmail.com"]
  spec.summary = "Sinatra extensions ... " # TODO
  spec.description = "" # TODO
  spec.homepage = "" # TODO
  spec.license = "" # TODO

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-contrib"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "geminabox"
  spec.add_development_dependency "rspec"
end

