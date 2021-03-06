require_relative 'lib/opal/optimizer/version'

Gem::Specification.new do |spec|
  spec.name          = "opal-optimizer"
  spec.version       = Opal::Optimizer::VERSION
  spec.authors       = ["hmdne"]
  spec.email         = []

  spec.summary       = %q{Optimize Opal's resulting javascript code}
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/hmdne/opal-optimizer"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/hmdne/opal-optimizer"
  spec.metadata["changelog_uri"] = "https://github.com/hmdne/opal-optimizer/commits/master"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rkelly-turbo"
  spec.add_dependency "opal", ">= 1.0.0"
end
