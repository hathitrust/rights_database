# frozen_string_literal: true

require_relative "lib/rights_database/version"

Gem::Specification.new do |spec|
  spec.name = "rights_database"
  spec.version = RightsDatabase::VERSION
  spec.authors = ["Aaron Elkiss", "Brian \"Moses\" Hall", "Josh Steverman"]

  spec.summary = "HathiTrust Rights Database API"
  spec.description = "HathiTrust Rights Database API"
  spec.homepage = "https://github.com/hathitrust/rights_database"
  spec.license = "BSD-3-Clause"
  spec.required_ruby_version = ">= 3.1.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bins"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "sequel"
  spec.add_dependency "mysql2"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
