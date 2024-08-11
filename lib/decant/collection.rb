# frozen_string_literal: true
require 'pathname'

module Decant
  class Collection
    attr_reader :dir, :ext

    def initialize(dir:, ext: nil)
      self.dir = dir
      self.ext = ext
    end

    def dir=(value)
      @dir = Pathname.new(value)
    end

    def entries
      glob("**/*#{ext}")
    end

    def ext=(value)
      if value
        @ext = value.start_with?('.') ? value : ".#{value}"
      else
        @ext = value
      end
    end

    def find(path)
      pattern = "#{path}#{ext}"
      glob(pattern).first
    end

    def glob(pattern)
      dir.glob(pattern).select { |path| path.file? }
    end
  end
end
