# frozen_string_literal: true
require 'strscan'

module Decant
  module PathUtils
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
