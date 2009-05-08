require 'rubygems'
require 'treetop'
require 'pp'

def mypp(*s)
  #pp s
end


module Treetop
  class Utils
    def self.mash_result(result_array)
      result_array.flatten.map{|hash| hash.values()[0]}.join
    end

    def self.get_grammar(file)
      grammar_parser = Treetop::Compiler::MetagrammarParser.new

      grammar_text = ''
      File.open(file) do |source_file|
        grammar_text = source_file.read
      end
      grammar_parser.parse(grammar_text)
    end
  end

  module Runtime
    class SyntaxNode
      def generate
        return [ self => ''] if text_value.start_with?('!') # it's a prefix condition, ignore it

        result = []
        if elements
          elements.each do |e|
            result << e.generate
          end
        end
        [ self => Utils.mash_result(result) ]
      end
    end
  end

  module Compiler
    
    # Optional - in SyntaxNode

    class Grammar
      @@rules = {}        # name - definition hash
      
      def self.rules; @@rules end

      def self.add_rules(rules_array)
        rules_array.each do |r|
          @@rules[r.nonterminal.text_value] = r
        end
      end

      def extract_rules
        rules = []

        declarations = []
        declarations << declaration_sequence.head
        declaration_sequence.tail.each do |tail|
          declarations << tail
        end

        # modules
        modules = declarations.select{ |r| r.class != ParsingRule }
        modules.each do |m|
          name = m.text_value['include '.length..-1].downcase
          file = "lib/grammar/#{name}.treetop"
          parsed_module = Utils.get_grammar(file)
          # hack: the grammar is on the first level
          grammar = parsed_module.elements.select{|e| e.class == Grammar}.first
          Grammar.add_rules(grammar.extract_rules)
        end

        # keep only the rules
        declarations.select{ |r| r.class == ParsingRule }
      end
      
      def generate
        rules_array = extract_rules()
        Grammar.add_rules(rules_array)
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
        #pp p.text_value, p.class.name, '------------------------------------'
        # something we know how to parse directly?
        if p.class != Runtime::SyntaxNode
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
            element = result.last.keys()[0]
            # add, if necessary
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
        [ self => Utils.mash_result(result) ]
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
        result = chosen.generate()
        [ self => Utils.mash_result(result) ]
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
          result << ParsingExpresion.generate(p)
        end
        [ self => Utils.mash_result(result) ]
      end
    end

    class Nonterminal
      def generate
        rule = Grammar.rules[text_value]
        if rule.nil?
          pp text_value
         1/0
        end
        rule.parsing_expression.generate
      end
    end
    
    class Terminal
      def generate
        # eliminate ' and "
        result = text_value.gsub(/'/, '').gsub(/"/, '')
        [self => result]
      end
    end

    class AnythingSymbol
      def generate
        [self => '&']
      end
    end

    class CharacterClass
      def generate
    #p 'character class', text_value
        # [0-9]
        [self => text_value[-2..-2]]
      end
    end
  end
end



grammar = Treetop::Utils.get_grammar('lib/grammar/vim.treetop')
result = grammar.generate
result = result.flatten.map{|m| m.values()[0]}
result = result.join
pp 'final: ', result


#check
#require 'lib/vimmish'
#pp Vimmish.parser.parse(result)
