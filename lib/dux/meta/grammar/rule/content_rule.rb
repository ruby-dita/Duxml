require File.expand_path(File.dirname(__FILE__) + '/../rule')

module Dux
  class ContentRule < Rule
    def qualify change_or_pattern

      super change_or_pattern unless pass scanners
    end
  end # class ContentRule
end # module Dux