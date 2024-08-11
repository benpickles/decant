# frozen_string_literal: true
require_relative 'frontmatter'

module Decant
  class File
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def content
      frontmatter_content[1]
    end

    def frontmatter
      frontmatter_content[0]
    end

    def frontmatter?(key = nil)
      return false if frontmatter.nil?
      key ? frontmatter.key?(key) : true
    end

    def read
      path.read
    end

    private
      def frontmatter_content
        @frontmatter_content ||= Frontmatter.load(read)
      end
  end
end
