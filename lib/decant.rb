# frozen_string_literal: true
require_relative 'decant/collection'
require_relative 'decant/content'
require_relative 'decant/version'

module Decant
  def self.define(dir:, ext: nil, &block)
    Class.new(Content) do
      @collection = Collection.new(dir: dir, ext: ext)
      class_eval(&block) if block_given?
    end
  end
end
