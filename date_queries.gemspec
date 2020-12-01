$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "date_queries/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "date_queries"
  s.version     = DateQueries::VERSION
  s.authors     = ["Allerin Test Gem"]
  s.email       = ["redmine@allerin.com"]
  s.homepage    = ""
  s.summary     = "A gem for date related queries"
  s.description = "Provides scopes for date related queries, such as records between dates with year/month skipped."

  s.rubyforge_project = "date_queries"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]


  s.add_dependency "rails", "~> 4.0.2"

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'

end
