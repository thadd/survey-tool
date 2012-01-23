module REXML
  class ParseException < RuntimeError

    # Try to make the sanest possible explanation of a parse error,
    # suitable for display to users
    #
    def explain
      str = self.to_s

      # If it's the broken 'missing tag start' error,
      # output the "unconsumed chars" as they serve as
      # a good hint to the location of the problem
      #
      if str.match(/missing tag start/)
        if str.match(/Last \d+ unconsumed characters:\n([^\n]+)\n/)
          "near #{$1}"
        else
          "(unknown)"
        end
      # Otherwise it's a normal error, so return the description
      #
      else
        if str.match(/REXML::ParseException: (.*)$/)
          "#{$1} [occurred on line #{self.line}]"
        else
          "(unknown)"
        end
      end
    end
  end
end
