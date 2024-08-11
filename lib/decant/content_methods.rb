# frozen_string_literal: true
require_relative 'errors'

module Decant
  module ContentMethods
    attr_reader :collection

    def all
      collection.entries.map { |path| new(path) }
    end

    def find(pattern)
      path = collection.find(pattern)
      raise FileNotFound, %(Couldn't find "#{pattern}" in "#{collection.dir}") unless path
      new(path)
    end

    def frontmatter(*attrs)
      attrs.each do |name|
        define_method name do
          frontmatter&.[](name.to_sym)
        end
      end
    end
  end
end
