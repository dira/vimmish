require 'rubygems'
require 'treetop'
require 'pp'

def mypp(*s)
  #pp s
end

module Treetop
  module Runtime
    class SyntaxNode
      def generate
        result = []
        if elements
          elements.each do |e|
            result << e.generate
          end
        end
        result
      end
    end
  end

  module Compiler
    
    # Optional - in SyntaxNode

    class Grammar
      @@rules = {}        # name - definition hash
      
      def self.rules; @@rules end

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
        ParsingExpresion.generate(parsing_expression)
      end
    end

    # is not defined in the grammar
    class ParsingExpresion
      def self.generate(p)
        if p.class == Choice
          return p.generate
        end
        
        result = []
        p.elements.each do |e|
          result = result.flatten
          #pp e.class.name, e.class == Treetop::Compiler::Optional, e.class == OneOrMore
          if e.class == Optional
            delete_it = (rand(2) == 1) 
            result.delete(result.last) if delete_it
          elsif e.class == OneOrMore
            how_many = rand(2)
            how_many = 1
            element = result.last.keys()[0]
            # add, if necessary
            p '+', element
            (1..how_many).each{|nr| result << element.generate }
          elsif e.class == ZeroOrMore
            how_many = rand(3)
            if (how_many == 0)
              result.delete(result.last)
            elsif (how_many > 1)
              element = result.last.keys()[0]
              (1..how_many - 1).each{|nr| result << element.generate }
            end
          else
            result << e.generate
          end
        end
        result
      end
    end
    
    class ParenthesizedExpression
      def generate
        ParsingExpresion.generate(parsing_expression)
      end
    end

    class Choice
      def generate
        # choose one
        chosen_index = rand(alternatives.size)
        chosen = alternatives[chosen_index]
        [self => chosen.generate().flatten[0].values()[0]]
      end
    end
    
    class Sequence
      def generate
        primaries = []
        primaries << head
        tail.each do |t| 
          primaries << t
        end
        result = []
        primaries.select{|p| p.respond_to?(:sequence_primary)}.map do |p|
          p = p.sequence_primary
          result = result + ParsingExpresion.generate(p)
        end
        result
      end
    end

    class Nonterminal
      def generate
        rule = Grammar.rules[text_value]
        rule.parsing_expression.generate
      end
    end
    
    class Terminal
      def generate
        {self => text_value.gsub(/'/, '')}
      end
    end

    class AnythingSymbol
      def generate; [self => '&'] end
    end

    class CharacterClass
      def generate
        # [0-9]
        {self => text_value[-2..-2]}
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
result = grammar.generate
result = result.flatten.map{|m| m.values()[0]}
pp 'end: ', result.join
#pp grammar
