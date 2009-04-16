require File.join(File.dirname(__FILE__), 'test_helper.rb')

#class Treetop::Runtime::SyntaxNode
#  def inspect
#    object_id.to_s + super
#  end
#end

require "lib/command"
require "lib/motion"
require "lib/macro_motion"
require "lib/parametric_motion"
require "test/assertions"

Treetop.load "lib/vim"

parser = VimParser.new

describe "Vimmish::Parser" do
  describe 'motions' do
    describe 'arrows' do
      include Assertions
      {
        'left' => ['h', '<LEFT>'],
        'down' => ['j', '<DOWN>'],
        'up' => ['k', '<UP>'],
        'right' => ['l', '<RIGHT>'],
      }.each_pair do |move, commands|
        commands.each do |vim|
          it "should parse #{vim} and translate correctly" do
            vim.should parse_to(parser, [vim, "move #{move}"])
          end
        end
      end
    end

    describe 'character movement' do
      include Assertions
      {
        'fy' => 'move on the next y',
        '2fy' => 'move on the next y, 2 times',
        'Fy' => 'move on the previous y',
        '2Fy' => 'move on the previous y, 2 times',
        'ty' => 'move to the next y',
        '2ty' => 'move to the next y, 2 times',
        'Ty' => 'move to the previous y',
        '2Ty' => 'move to the previous y, 2 times',
      }.each_pair do |vim, result|
        it "should parse #{vim} and translate correctly" do
          vim.should parse_to(parser, [vim, result])
        end
      end
    end

    describe 'word movement' do
      include Assertions
      {
        'w' => 'move to the begining of the next word',
        '4w' => 'move to the begining of the next word, 4 times',
        'b' => 'move to the begining of the previous word',
        '7b' => 'move to the begining of the previous word, 7 times',
        'e' => 'move to the end of the next word',
        '3e' => 'move to the end of the next word, 3 times',
        'ge' => 'move to the end of the previous word',
        '3ge' => 'move to the end of the previous word, 3 times',
        'B' => 'move backwards one space-separated-word',
        '7B' => 'move backwards one space-separated-word, 7 times',
        'E' => 'move to the end of the next space-separated-word',
        '3E' => 'move to the end of the next space-separated-word, 3 times',
        'gE' => 'move to the end of the previous space-separated-word',
        '3gE' => 'move to the end of the previous space-separated-word, 3 times',
      }.each_pair do |vim, result|
        it "should parse #{vim} and translate correctly" do
          vim.should parse_to(parser, [vim, result])
        end
      end
    end

    describe 'line movement' do
      include Assertions
      {
        '^'  => 'move to the begining of the line (not blank character)',
        '3^' => 'move to the begining of the line (not blank character)', # no effect
        '0' => 'move to the begining of the line', # cannot take count
        '$'  => 'move to the end of the line',
        '1$' => 'move to the end of the line',
        '3$' => 'move to the end of the line that is 2 lines below',
      }.each_pair do |vim, result|
        it "should parse #{vim} and translate correctly" do
          vim.should parse_to(parser, [vim, result])
        end
      end
    end

    describe 'syntax-dependent movement' do
      include Assertions
      {
        '%' => 'move to the matching paranthesys',
      }.each_pair do |vim, result|
        it "should parse #{vim} and translate correctly" do
          vim.should parse_to(parser, [vim, result])
        end
      end
    end

    
    describe 'moving to specific lines' do
      include Assertions
      {
        'G' => 'move to last line (end of file)',
        '3G' => 'move to line 3',
        'gg' => 'move to first line (beginning of file)',
        '15gg' => 'move to line 15',
        # TODO %90 = 90%
        # TODO H - home, M - middle, L - last
        # CTRL+U scroll down 50%, CTRL+D scroll up 50%,
        # CTRL+E scroll up 1 line, CTRL+Y scroll down 1 line,
        # CTRL+F scroll forward screen, CTRL+B scroll backword screen
      }.each_pair do |vim, result|
        it "should parse #{vim} and translate correctly" do
          vim.should parse_to(parser, [vim, result])
        end
      end
    end
  end
  
  describe "smoke tests" do
    #include Assertions
    ["d", "y"].each do |command|
      it "should parse #{command}" do
        parser.parse(command).should.not.be nil
      end
      ["w", "("].each do |motion|    
        it "should parse #{command}#{motion}" do
          parser.parse(command + motion).should.not.be nil
        end
      end
    end
  
    it "should not parse inexistant command" do
      parser.parse('q').should.be nil
      # p parser.failure_reason
    end
  end
  
  describe 'normal mode commands' do
    include Assertions

    it "should parse change word with something" do
      vim = "cwrandom blah>blah<blah<ES><ESC>"
      result = [
        ['cw', 'change to the begining of the next word'],
        ['random blah>blah<blah<ES>', 'type random blah>blah<blah<ES>'],
        ['<ESC>', 'go to normal mode'],
      ]
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
    }.each_pair do |vim, result|
      it "should parse #{vim}" do
        vim.should parse_to(parser, result)
      end
    end
  end
 
  describe 'visual mode' do
    include Assertions

    #it "should parse vw~" do
      #vim = "vw~"
      #result = [
        #['v', 'go to visual mode'],
        #['w', 'select ot the begining of the next word'],
        #['~', 'make uppercase']
      #]
      #vim.should parse_to(parser, result)
    #end

    #it "should parse v$" do
      #vim = "v$"
      #result = [
        #['v', 'go to visual mode'],
        #['w', 'select to the end of the line'],
      #]
      #vim.should parse_to(parser, result)
    #end

    #it "should parse gv" do
      #vim = "gv"
      #result = [
        #['gv', 'restore previous visual selection'],
      #]
      #vim.should parse_to(parser, result)
    #end

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

  describe "commands" do
    include Assertions

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

  describe "command_mode" do
    include Assertions
    it "should parse command mode with substitute" do
      vim = ":s/gogo/gaga<CR>"
      result = [
        [':', 'go to command mode'],
        ['s', 'substitute'], 
        ['/gogo', 'find gogo'], 
        ['/gaga', 'replace with gaga'],
        ['<CR>', 'execute command and go to normal mode']
      ]
      vim.should parse_to(parser, result)
    end

    [ 
      ["12,14", 'line 12 to line 14'] ,
      ["^,14", 'first line to line 14'] ,
      ["12,$", 'line 12 to last line'] ,
      ["12,.", 'line 12 to current line'] ,
      [".,+2", 'current line to the next 2 line(s)'] ,
      [".,-2", 'current line to the previous 2 line(s)'] ,
    ].each do |range, humanized|
      it "should parse delete range #{range}" do
        vim = ":#{range}d<CR>" 
        result = [
          [':', 'go to command mode'],
          [range, "select range: #{humanized}"], 
          ['d', 'delete range'], 
          ['<CR>', 'execute command and go to normal mode']
        ]
        vim.should parse_to(parser, result)
     end
   end
  end
end
