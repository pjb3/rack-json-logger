Gem::Specification.new do |spec|
  spec.name          = "rack-json-logger"
  spec.version       = "0.1.0"
  spec.authors       = ["Paul Barry"]
  spec.email         = ["pauljbarry3@gmail.com"]

  spec.summary       = "Rack middleware to log the information about request and response in JSON format"
  spec.description   = "Rack middleware to log the information about request and response in JSON format"
  spec.homepage      = "https://github.com/pjb3/rack-json-logger"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
