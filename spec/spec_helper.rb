# frozen_string_literal: true

require "simplecov"
require "simplecov-lcov"

SimpleCov.add_filter "spec"

SimpleCov::Formatter::LcovFormatter.config do |c|
  c.report_with_single_file = true
  c.single_report_path = "coverage/lcov.info"
end
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::LcovFormatter
])

SimpleCov.start

require "rights_database"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Temporarily manipulate ENV within a block.
def ENV.with(**kwargs)
  save_env = ENV.select { |k, _v| kwargs.key? k }
  delete_env = kwargs.reject { |k, _v| ENV.key? k.to_s }
  retval = nil
  begin
    kwargs.each { |k, v| ENV[k.to_s] = v }
    retval = yield if block_given?
  ensure
    save_env.each { |k, v| ENV[k] = v }
    delete_env.each { |k, _v| ENV.delete k.to_s }
  end
  retval
end
