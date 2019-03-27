$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "minikas_payable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "minikas_payable"
  spec.version     = MinikasPayable::VERSION
  spec.authors       = ["Voksenopplæringsforbundet", "Mats Grimsgaard"]
  spec.email         = ["vofo@vofo.no"]

  spec.summary       = %q{Payable Engine for Rails.}
  spec.homepage      = "https://github.com/vofo-no/minikas_payable"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.2", ">= 5.2.2.1"

  spec.add_development_dependency "sqlite3", "~> 1.3.6"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "factory_bot_rails"
end
