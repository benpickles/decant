# frozen_string_literal: true
require_relative 'decant/collection'
require_relative 'decant/content'
require_relative 'decant/version'

module Decant
  # Defines a new {Content} subclass and assigns it a new {Collection} with
  # +dir+/+ext+. Passing a block lets you to declare convenience frontmatter
  # readers and add your own methods.
  #
  # @example
  #   Page = Decant.define(dir: 'content', ext: 'md') do
  #     frontmatter :title
  #
  #     def shouty
  #       "#{title.upcase}!!!"
  #     end
  #   end
  #
  #   # Given a file `content/about.md` with the following contents:
  #   #
  #   # ---
  #   # title: About
  #   # ---
  #   # About Decant
  #
  #   about = Page.find('about')
  #   about.content     # => "About Decant"
  #   about.frontmatter # => {:title=>"About"}
  #   about.title       # => "About"
  #   about.shouty      # => "ABOUT!!!"
  #
  # @param dir [Pathname, String]
  # @param ext [String, nil]
  #
  # @yield pass an optional block to declare convenience frontmatter readers
  #   with {Content.frontmatter} and add your own methods to the class.
  #
  # @return [Class<Content>]
  def self.define(dir:, ext: nil, &block)
    Class.new(Content) do
      @collection = Collection.new(dir: dir, ext: ext)
      class_eval(&block) if block_given?
    end
  end
end
