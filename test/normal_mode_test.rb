require File.join(File.dirname(__FILE__), 'test_helper.rb')
parser = VimParser.new

describe 'normal mode commands' do
  include Assertions

  it "should parse change word with something" do
    vim = "cwrandom blah>blah<blah<ES><ESC>"
    result = [
      ['cw', 'change to the begining of the next word'],
      ['random blah>blah<blah<ES>', 'type random blah>blah<blah<ES>'],
      ['<ESC>', 'go to normal mode'],
    ]
    vim.should parse_to(parser, result)
  end

  {
    'dw'  => [ ['dw', 'delete to the begining of the next word'] ],
    "daw" => [ ['daw', 'delete a word'] ],
    "d1w" => [ ['d1w', 'delete to the begining of the next word'] ],
    "d2w" => [ ['d2w', 'delete to the begining of the next word, 2 times'] ],
    "diw" => [ ['diw', 'delete inner word'] ],
    "y("  => [ ['y(', 'yank sentence'] ],
    "2dw" => [ ['2',  '2 times: '], ['dw', 'delete to the begining of the next word'] ],
    "2dw2dw" => [
        ['2',  '2 times: '],
        ['dw', 'delete to the begining of the next word'],
      ] * 2,
    #"x" => [ ['x', 'delete a character'] ],
    #"4x" => [ ['4', '4 times:'],
              #['x', 'delete a character'] ],
  }.each_pair do |vim, result|
    it "should parse #{vim}" do
      vim.should parse_to(parser, result)
    end
  end


  #it "should parse dd" do
    #vim = "dd"
    #result = [
      #['dd', 'delete current line']
    #]
    #vim.should parse_to(parser, result)
  #end
  
  #it "should parse cc" do
    #vim = "cc"
    #result = [
      #['cc', 'change current line']
    #]
    #vim.should parse_to(parser, result)
  #end

  it "should parse c<RIGHT>" do
    vim = 'c<RIGHT>'
    result = [
      ['c', 'change'],
      ['<RIGHT>', 'one character to the right']
    ]
  end

  #it "should parse D" do
    #vim = "D"
    #result = [
      #['D', 'delete the rest of the current line']
    #]
    #vim.should parse_to(parser, result)
  #end
  #it "should parse 3D" do
    #vim = "3D"
    #result = [
      #['3D', 'delete the rest of the current line, 3 times'] # TODO it advances too..
    #]
    #vim.should parse_to(parser, result)
  #end

  #it "should parse C" do
    #vim = "C"
    #result = [
      #['C', 'change the rest of the current line']
    #]
    #vim.should parse_to(parser, result)
  #end

  #it "should parse 4C" do
    #vim = "4C"
    #result = [
      #[vim, 'change the rest of the current line, 4 times']# TODO it advances too..
    #]
    #vim.should parse_to(parser, result)
  #end

  #it "should parse J" do
    #vim = "J"
    #result = [
      #['J', 'unite current line with the next one']
    #]
    #vim.should parse_to(parser, result)
  #end
end
