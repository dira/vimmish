require 'rubygems'
require 'treetop'

require 'lib/grammar/command'
require 'lib/grammar/motion'
require 'lib/grammar/macro_motion'
require 'lib/grammar/parametric_motion'

require 'lib/grammar/vimcommandranges'
require 'lib/grammar/viminsert'
require 'lib/grammar/vim'

class Treetop::Runtime::SyntaxNode
  def inspect
    self.eval.map{|command, translation| "#{sprintf("%20s => %s",command, translation)}"}.join("\n")
  end
end

class Vimmish
  @@parser = nil

  def self.parser
    @@parser = @@parser || VimParser.new
  end

  def self.humanize(vim)
    parser.parse(vim)
  end
end
