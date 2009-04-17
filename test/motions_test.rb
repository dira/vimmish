require File.join(File.dirname(__FILE__), 'test_helper.rb')
parser = VimParser.new

describe 'motions' do
  describe 'arrows' do
    include Assertions
    {
      'one character to the left' => ['h', '<LEFT>'],
      'one character to the down' => ['j', '<DOWN>'],
      'one character to the up' => ['k', '<UP>'],
      'one character to the right' => ['l', '<RIGHT>'],
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
