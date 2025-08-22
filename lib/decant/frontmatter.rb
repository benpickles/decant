# frozen_string_literal: true
require 'date'
require 'strscan'
require 'yaml'

module Decant
  module Frontmatter
    # Additional permitted classes passed to +YAML.safe_load+ via {.load}.
    PERMITTED_CLASSES = [::Date, ::Time]

    # Parse a +String+ input (the contents of a file) into its frontmatter /
    # content constituents.
    #
    # For frontmatter to be valid/detected the +input+ must start with a line
    # consisting of three dashes +---+, then the YAML, then another line of
    # three dashes. The returned +Hash+ will have +Symbol+ keys.
    #
    # Technically frontmatter can be any valid YAML not just key/value pairs but
    # this would be very unusual and wouldn't be compatible with other
    # frontmatter-related expectations like {Content.frontmatter}.
    #
    # @example Input with valid frontmatter
    #   ---
    #   title: Frontmatter
    #   ---
    #   The rest of the content
    #
    # @example Result of loading the above input
    #   Decant::Frontmatter.load(string)
    #   # => [{:title=>"Frontmatter"}, "The rest of the content"]
    #
    # @param input [String]
    #
    # @return [Array([Hash<Symbol, anything>, nil], String)] a frontmatter /
    #   content tuple. If +input+ contains frontmatter then the YAML will be
    #   parsed into a +Hash+ with +Symbol+ keys, if it doesn't have frontmatter
    #   then it will be +nil+.
    def self.load(input)
      return [nil, input] unless input.start_with?("---\n")

      scanner = StringScanner.new(input)
      scanner.skip("---\n")
      scanner.skip_until(/^---$\n?/)
      yaml = scanner.pre_match

      return [nil, input] unless yaml

      data = YAML.safe_load(
        yaml,
        permitted_classes: PERMITTED_CLASSES,
        symbolize_names: true,
      )

      [
        data || {},
        scanner.post_match
      ]
    end
  end
end
