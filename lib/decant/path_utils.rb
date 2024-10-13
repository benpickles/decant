# frozen_string_literal: true
require 'strscan'

module Decant
  module PathUtils
    # Generate a regular expression to strip a matching extension from a string.
    # Supports similar shell-like pattern syntax as +Dir.glob+ including +.*+
    # to remove any extension and +.{a,b}+ to remove either an +.a+ or +.b+
    # extension. Used internally by {Content#slug}.
    #
    # @param pattern [String]
    #
    # @return [Regexp]
    #
    # @raise [RegexpError] if the regular expression cannot be generated, for
    #   instance if +pattern+ includes unbalanced shell-like expansion brackets
    def self.delete_ext_regexp(pattern)
      scanner = StringScanner.new(pattern)
      regexp = String.new

      while (ch = scanner.getch)
        regexp << case ch
        when '.' then '\.'
        when '{' then '(?:'
        when ',' then '|'
        when '}' then ')'
        when '*' then '[^\.]+'
        else
          ch
        end
      end

      regexp << '$'

      Regexp.new(regexp)
    end
  end
end
