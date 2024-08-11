# frozen_string_literal: true
require 'strscan'
require 'yaml'

module Decant
  module Frontmatter
    def self.load(input)
      return [nil, input] unless input.start_with?("---\n")

      scanner = StringScanner.new(input)
      scanner.skip("---\n")
      scanner.skip_until(/^---$\n?/)
      yaml = scanner.pre_match

      return [nil, input] unless yaml

      [
        YAML.safe_load(yaml, symbolize_names: true) || {},
        scanner.post_match
      ]
    end
  end
end
