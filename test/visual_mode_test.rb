require File.join(File.dirname(__FILE__), 'test_helper.rb')
parser = Vimmish.parser

describe 'visual mode' do
  include Assertions

  it "should parse vw~" do
    vim = "vw~"
    result = [
      ['v', 'go to visual mode'],
      ['w', 'select to the begining of the next word'],
      ['~', 'change character case']
    ]
    vim.should parse_to(parser, result)
  end

  it "should parse v$d" do
    vim = "v$d"
    result = [
      ['v', 'go to visual mode'],
      ['$', 'select to the end of the line'],
      ['d', 'delete selection'],
    ]
    vim.should parse_to(parser, result)
  end

  it "should parse gv<RIGHT><UP>d" do
    vim = "gv<RIGHT><UP>d"
    result = [
      ['gv', 'restore previous visual selection'],
      ['<RIGHT>', 'select one character to the right'],
      ['<UP>', 'select up'],
      ['d', 'delete selection']
    ]
    vim.should parse_to(parser, result)
  end

  it "should parse v3wcabcde<ESC>" do
    vim = "v3wcabcde<ESC>"
    result = [
      ['v', 'go to visual mode'],
      ['3w', 'select to the begining of the next word, 3 times'], 
      [
        ['c', 'change selection'], 
        ['abcde', 'type abcde'],
        ['<ESC>', 'go to normal mode']
        ]
    ]
    vim.should parse_to(parser, result)
  end
end

