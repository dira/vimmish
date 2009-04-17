require File.join(File.dirname(__FILE__), 'test_helper.rb')
parser = VimParser.new

describe 'insert commands' do
  include Assertions

  [
    ['cc', 'change current line with: '], 
    ['C', 'change the rest of the current line with: '],
    ['s', 'substitute character with: '],
    ['S', 'substitute line with: '],
  ].each do |vim_partial, result_partial|
    vim = "#{vim_partial}abc<ESC>"
    result = [
      [vim_partial, result_partial],
      ['abc', 'type abc'],
      ['<ESC>', 'go to normal mode'],
    ]
    it "should parse #{vim}" do
      vim.should parse_to(parser, result)
    end
    it "should parse 4#{vim}" do
      "4#{vim}".should parse_to(parser, [['4', '4 times: ']] + result)
    end
  end

  it "should parse change right with something" do
    vim = "c<RIGHT>random blah>blah<blah<ES><ESC>"
    result = [
      ['c<RIGHT>', 'change one character to the right'],
      ['random blah>blah<blah<ES>', 'type random blah>blah<blah<ES>'],
      ['<ESC>', 'go to normal mode'],
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

  [
    ['i', 'insert before cursor: '],
    ['I', 'insert to the begining of the current line: '],
    ['a', 'append after cursor: '],
    ['A', 'append to the end of the current line: '],
    ['o', 'open a new line below and insert: '],
    ['O', 'open a new line above and insert: '],
  ].each do |vim_partial, result_partial|
    vim = "#{vim_partial}abc<ESC>"
    it "should parse #{vim}" do
      result = [
        [vim_partial, result_partial],
        ['abc', 'type abc'],
        ['<ESC>', 'go to normal mode']
      ]
      vim.should parse_to(parser, result)
    end
  end
end
