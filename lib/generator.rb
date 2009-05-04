require 'rubygems'
require 'treetop'
require 'pp'

module Treetop
  module Runtime
    class SyntaxNode
      def generate
        result = []
        if elements
          elements.each do |e|
            if (e.class == Compiler::Optional)
              result.delete(result.last) if (rand(2) == 1)
            else
              result << e.generate
            end
          end
        end
        result.join
      end
    end
  end

  module Compiler
    
    # Sequence - same as SyntaxNode
    # Optional - in SyntaxNode

    class Grammar
      def rules
        # get all the declaration
        rules = []
        declarations = declaration_sequence
        rules << declarations.head
        declarations.tail.each do |tail|
          rules << tail
        end
        # keep only the rules
        rules.select{ |r| r.class == ParsingRule }
      end
      
      def generate
        rules_array = rules()
        rules = {}
        rules_array.each do |r|
          rules[r.nonterminal.text_value] = r
        end
        rules_array[0].generate
      end
    end

    class Choice
      def generate
        # choose one
        chosen_index = rand(alternatives.size)
        # TODO change
        chosen_index = 0
        chosen = alternatives[chosen_index]
        pp chosen.text_value, chosen
        chosen.generate
      end
    end

    class Terminal
      def generate
        text_value
      end
    end

    class AnythingSymbol
      def generate; '&' end
    end

    class CharacterClass
      def generate
        'character class:' + text_value
      end
    end
  
  end
end


grammar_parser = Treetop::Compiler::MetagrammarParser.new

grammar_text = ''
File.open('lib/grammar/vim.treetop') do |source_file|
  grammar_text = source_file.read
end 
grammar = grammar_parser.parse(grammar_text)
pp grammar.generate
#pp grammar
