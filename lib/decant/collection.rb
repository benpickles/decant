# frozen_string_literal: true
require 'pathname'
require_relative 'path_utils'

module Decant
  class Collection
    # @return [Pathname]
    attr_reader :dir

    # @return [String, nil]
    attr_reader :ext

    # @param dir [Pathname, String]
    # @param ext [String, nil]
    def initialize(dir:, ext: nil)
      self.dir = dir
      self.ext = ext
    end

    # @return [Array<Pathname>]
    def entries
      glob('**/*')
    end

    # If {#ext} is defined then +pattern+ MUST NOT include the file's extension
    # as it will automatically be added, if {#ext} is +nil+ then +pattern+ MUST
    # include the file's extension - essentially becoming the file's full
    # relative path within {#dir}.
    #
    # Technically +pattern+ can be any pattern supported by +Dir.glob+ though
    # it's more likely to simply be a file name.
    #
    # @param pattern [String]
    #
    # @return [Pathname, nil]
    def find(pattern)
      glob(pattern).first
    end

    # @param pattern [String]
    #
    # @return [Array<Pathname>]
    def glob(pattern)
      dir.glob("#{pattern}#{ext}").select { |path| path.file? }
    end

    # The relative path of +path+ within {#dir}.
    #
    # @param path [Pathname]
    #
    # @return [String]
    def relative_path_for(path)
      path.relative_path_from(dir).to_s
    end

    # The extension-less relative path of +path+ within {#dir}.
    #
    # @param path [Pathname]
    #
    # @return [String]
    def slug_for(path)
      relative_path = relative_path_for(path)

      # The collection has no configured extension, files are identified by
      # their full (relative) path so there's no extension to remove.
      return relative_path if @delete_ext_regexp.nil?

      relative_path.sub(@delete_ext_regexp, '')
    end

    private
      def dir=(value)
        @dir = Pathname.new(value)
      end

      def ext=(value)
        if value
          @ext = value.start_with?('.') ? value : ".#{value}"
          @delete_ext_regexp = PathUtils.delete_ext_regexp(ext)
        else
          @ext = nil
          @delete_ext_regexp = nil
        end
      end
  end
end
