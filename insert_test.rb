require File.join(File.dirname(__FILE__), 'test_helper.rb')
parser = VimParser.new

describe 'insert commands' do
  include Assertions

  it "should parse cc" do
    vim = "cc"
    result = [
      ['cc', 'change current line']
    ]
    vim.should parse_to(parser, result)
  end

  it "should parse c<RIGHT>a<ESC>" do
    vim = 'c<RIGHT>a<ESC>'
    result = [
      ['c<RIGHT>', 'change one character to the right'],
      ['a', 'type a'],
      ['<ESC>', 'go to normal mode'],
    ]
    vim.should parse_to(parser, result)
  end

  it "should parse C" do
    vim = "C"
    result = [
      ['C', 'change the rest of the current line']
    ]
    vim.should parse_to(parser, result)
  end

  it "should parse 4C" do
    vim = "4C"
    result = [
      ['4', '4 times: '],
      ['C', 'change the rest of the current line'] # TODO it deletes the next 3 lines, and changes the current line..
    ]
    vim.should parse_to(parser, result)
  end

  it "should parse change word with something" do
    vim = "cwrandom blah>blah<blah<ES><ESC>"
    result = [
      ['cw', 'change to the begining of the next word'],
      ['random blah>blah<blah<ES>', 'type random blah>blah<blah<ES>'],
      ['<ESC>', 'go to normal mode'],
    ]
    vim.should parse_to(parser, result)
  end
end
