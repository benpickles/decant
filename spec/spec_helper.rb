# frozen_string_literal: true
require 'decant'
require 'tmpdir'

module FileHelpers
  def file(path, content = nil)
    full_path = file_path(path)

    if path.end_with?('/')
      FileUtils.mkdir_p(full_path)
    else
      FileUtils.mkdir_p(full_path.dirname)
      full_path.write(content)
    end
  end

  def file_path(path)
    Pathname.new(tmpdir).join(path)
  end

  def tmpdir
    return @tmpdir if defined?(@tmpdir)
    @tmpdir = Dir.mktmpdir
  end
end

RSpec.configure do |config|
  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = 'spec/examples.txt'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  config.include FileHelpers
  config.after do
    FileUtils.remove_entry(tmpdir) if defined?(@tmpdir)
  end
end
