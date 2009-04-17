require 'rubygems'
require 'treetop'

require 'lib/grammar/command'
require 'lib/grammar/motion'
require 'lib/grammar/macro_motion'
require 'lib/grammar/parametric_motion'

require 'lib/grammar/vimcommandranges'
require 'lib/grammar/viminsert'
require 'lib/grammar/vim'

require 'pp'

class Treetop::Runtime::SyntaxNode
  def inspect
    self.eval.map{|command, translation| "#{sprintf("%20s => %s",command, translation)}"}.join("\n")
  end
end

class VimParserFactory
  @@parser = nil

  def self.get_vim_parser
    @@parser = @@parser || VimParser.new
  end
end
