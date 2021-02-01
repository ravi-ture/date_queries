require_relative 'lib/date_queries/version'

Gem::Specification.new do |spec|
  spec.name          = "date_queries"
  spec.version       = DateQueries::VERSION
  spec.authors       = ["Ravi Ture"]
  spec.email         = ["raviture@gmail.com"]

  spec.summary       = %q{A gem for date related database queries}
  spec.description   = %q{Provides scopes for date related database queries, such as records between dates with year/month skipped.}
  spec.homepage      = "https://github.com/ravi-ture/date_queries"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ravi-ture/date_queries"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
