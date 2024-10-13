# frozen_string_literal: true
require_relative 'frontmatter'

module Decant
  class File
    # @return [Pathname]
    attr_reader :path

    # @param path [Pathname]
    def initialize(path)
      @path = path
    end

    # The "content" part of the file at {#path} - everything after the end of
    # the frontmatter definition (see {Frontmatter.load} for more about
    # frontmatter).
    #
    # @return [String]
    def content
      frontmatter_content[1]
    end

    # The frontmatter data contained in the file at {#path} or +nil+ if there's
    # none (see {Frontmatter.load} for more about frontmatter).
    #
    # @return [Hash<Symbol, anything>, nil]
    def frontmatter
      frontmatter_content[0]
    end

    # When passing a +key+ the return value indicates whether {#frontmatter} has
    # the +key+, when no +key+ is passed it indicates whether the file has any
    # frontmatter at all.
    #
    # @param key [Symbol, nil]
    #
    # @return [Boolean]
    def frontmatter?(key = nil)
      return false if frontmatter.nil?
      key ? frontmatter.key?(key) : true
    end

    # The full untouched contents of the file at {#path}.
    #
    # @return [String]
    def read
      path.read
    end

    private
      def frontmatter_content
        @frontmatter_content ||= Frontmatter.load(read)
      end
  end
end
