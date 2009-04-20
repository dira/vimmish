require 'rubygems'
require 'treetop'

require 'lib/grammar/command'
require 'lib/grammar/motion'
require 'lib/grammar/macro_motion'
require 'lib/grammar/parametric_motion'

require 'lib/grammar/vimcommandranges'
require 'lib/grammar/viminsert'
require 'lib/grammar/vim'

class Vimmish
  @@parser = nil

  def self.parser
    @@parser = @@parser || VimParser.new
  end

  def self.humanize(vim)
    parser.parse(vim).eval
  end
end

class VimmishFormatters
  def self.pretty(humanized, width=20)
    humanized.map do |command, translation| 
      "#{sprintf("%#{width}s => %s", command, translation)}"
    end
  end
end
