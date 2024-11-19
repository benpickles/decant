# frozen_string_literal: true
require_relative 'errors'
require_relative 'file'

module Decant
  class Content < File
    class << self
      # When using {Decant.define} the returned {Content} subclass comes with
      # its own {Collection} instance.
      #
      # @return [Collection]
      attr_reader :collection

      # Return all matching files within {.collection}.
      #
      # @return [Array<Content>]
      def all
        collection.entries.map { |path| new(path) }
      end

      # Find a file within the {.collection} by passing its relative path.
      #
      # @example Find a specific nested file within a content directory
      #   Page = Decant.define(dir: 'content', ext: '.md')
      #
      #   # Return an instance for the file `content/features/nesting.md`.
      #   Page.find('features/nesting')
      #
      # @param pattern [String]
      #
      # @return [Content]
      #
      # @raise [FileNotFound] if a matching file cannot be found
      def find(pattern)
        path = collection.find(pattern)
        raise FileNotFound, %(Couldn't find "#{pattern}" in "#{collection.dir}") unless path
        new(path)
      end

      # Define convenience frontmatter readers - see {Decant.define}.
      #
      # @param attrs [Array<Symbol>] a list of convenience frontmatter readers.
      def frontmatter(*attrs)
        attrs.each do |name|
          define_method name do
            frontmatter&.[](name.to_sym)
          end
        end
      end
    end

    # The relative path of the file within its collection.
    #
    # @example
    #   Page = Decant.define(dir: 'content', ext: 'md')
    #
    #   page = Page.find('features/slugs')
    #   page.path.expand_path # => "/Users/dave/my-website/content/features/slugs.md"
    #   page.relative_path    # => "features/slugs.md"
    #
    # @return [String]
    def relative_path
      self.class.collection.relative_path_for(path)
    end

    # The extension-less relative path of the file within its collection.
    #
    # @example
    #   Page = Decant.define(dir: 'content', ext: 'md')
    #
    #   page = Page.find('features/slugs')
    #   page.path.expand_path # => "/Users/dave/my-website/content/features/slugs.md"
    #   page.slug             # => "features/slugs"
    #
    # @return [String]
    def slug
      self.class.collection.slug_for(path)
    end
  end
end
