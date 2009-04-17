require File.join(File.dirname(__FILE__), 'test_helper.rb')
parser = Vimmish.parser

describe 'normal mode commands' do
  include Assertions

  {
    'dw'  => [ ['dw', 'delete to the begining of the next word'] ],
    "daw" => [ ['daw', 'delete a word'] ],
    "d1w" => [ ['d1w', 'delete to the begining of the next word'] ],
    "d2w" => [ ['d2w', 'delete to the begining of the next word, 2 times'] ],
    "diw" => [ ['diw', 'delete inner word'] ],
    "y("  => [ ['y(', 'yank sentence'] ],
    "d3w" => [ ['d3w', 'delete to the begining of the next word, 3 times'] ],
    "x" =>  [ ['x', 'delete a character'] ],
    "~" =>  [ ['~', 'change character case'] ],
  }.each_pair do |vim, result|
    it "should parse #{vim}" do
      vim.should parse_to(parser, result)
    end
    it "should parse 3#{vim}" do
      "3#{vim}".should parse_to(parser, [['3', '3 times: ']] + result)
    end
  end

  {
    'D' =>  [ ['D', 'delete the rest of the current line'] ], # TODO with count it advances too..
    'J' =>  [ ['J', 'unite the current line with the next one'] ],
    'dd' => [ ['dd', 'delete current line'] ],
  }.each_pair do |vim, result|
    it "should parse #{vim}" do
      vim.should parse_to(parser, result)
    end
    it "should parse 5#{vim}" do
      "5#{vim}".should parse_to(parser, [['5', '5 times: ']] + result)
    end
  end
end
