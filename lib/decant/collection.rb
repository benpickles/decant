# frozen_string_literal: true
require 'pathname'
require_relative 'path_utils'

module Decant
  class Collection
    attr_reader :dir, :ext

    def initialize(dir:, ext: nil)
      self.dir = dir
      self.ext = ext
    end

    def entries
      glob("**/*#{ext}")
    end

    def find(path)
      pattern = "#{path}#{ext}"
      glob(pattern).first
    end

    def glob(pattern)
      dir.glob(pattern).select { |path| path.file? }
    end

    def slug_for(path)
      relative_path = path.relative_path_from(dir).to_s

      # The collection has no configured extension, files are identified by
      # their full (relative) path so there's no extension to remove.
      return relative_path if ext.nil?

      regexp = PathUtils.delete_ext_regexp(ext)
      relative_path.sub(regexp, '')
    end

    private
      def dir=(value)
        @dir = Pathname.new(value)
      end

      def ext=(value)
        if value
          @ext = value.start_with?('.') ? value : ".#{value}"
        else
          @ext = value
        end
      end
  end
end
