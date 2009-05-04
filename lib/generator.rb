require 'rubygems'
require 'treetop'
require 'pp'

def mypp(*s)
  pp s
end

module GenericParser
  def generate
    result = []
    mypp 'parsing:', text_value, self
    if elements
      elements.each do |e|
        mypp '          ', e.text_value
        case e.class
          when Treetop::Compiler::Optional
            mypp 'optional'
            result.delete(result.last) if (rand(2) == 1)
          when Treetop::Compiler::OneOrMore
            mypp 'one or more'
            how_many = rand(3)
            element = result.last.key
            # add, if necessary
            #(0..how_many).each{|nr| result << element.generate }
          when Treetop::Compiler::ZeroOrMore
            mypp 'zero or more'
            how_many = rand(3)
            if (how_many == 0)
              result.delete(result.last)
            elsif (how_many > 1)
              #(0..how_many - 1).each{|nr| result << element.generate }
            end
        else
          result << Treetop::Compiler::Grammar.execute(e)
        end
      end
    end
    mypp '-------'
    result.flatten
  end
end


module Treetop
  module Runtime
    class SyntaxNode
      include GenericParser
    end
  end

  module Compiler
    
    # Sequence - same as SyntaxNode
    # Optional - in SyntaxNode

    class Grammar
      @@rules = {}        # name - definition hash
      
      def self.rules; @@rules end

      def self.execute(element)
        if element.elements && element.elements[0].class == Nonterminal
          rule = Grammar.rules[element.text_value]
          rule.parsing_expression.generate
        else
          element.generate
        end
      end

      def extract_rules
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
        rules_array = extract_rules()
        rules_array.each do |r|
          @@rules[r.nonterminal.text_value] = r
        end
        rules_array[0].generate
      end
    end

    class ParsingRule
      def generate
        parsing_expression.generate 
      end
    end
    
    class ParenthesizedExpression
      def generate
        parsing_expression.generate 
      end
    end

    class Choice
      def generate
      mypp 'choice' + text_value
        # choose one
        chosen_index = rand(alternatives.size)
        # TODO change
        chosen_index = 0
        chosen = alternatives[chosen_index]
        Grammar.execute(chosen) 
      end
    end

    class Terminal
      def generate
      mypp 'Terminal' + text_value
        [self => text_value]
      end
    end

    class AnythingSymbol
      def generate; [self => '&'] end
    end

    #class CharacterClass
      #def generate
        #'character class:' + text_value
      #end
    #end
  
  end
end


grammar_parser = Treetop::Compiler::MetagrammarParser.new

grammar_text = ''
File.open('lib/grammar/vim.treetop') do |source_file|
  grammar_text = source_file.read
end 
grammar = grammar_parser.parse(grammar_text)
result = grammar.generate
pp result.map{|e| e.values()[0]}
#pp grammar
