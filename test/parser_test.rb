require File.join(File.dirname(__FILE__), 'test_helper.rb')

#class Treetop::Runtime::SyntaxNode
#  def inspect
#    object_id.to_s + super
#  end
#end

require "humanize/command"
require "humanize/motion"
require "humanize/macromotion"

Treetop.load "humanize/vim"

parser = VimParser.new

describe "Vimmish::Parser" do
  setup do 
  end
  
  describe "smoke tests" do
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
  
  describe 'motions' do
    describe 'arrows' do
      {
        'left' => ['h', '<LEFT>'],
        'down' => ['j', '<DOWN>'],
        'up' => ['k', '<UP>'],
        'right' => ['l', '<RIGHT>'],
      }.each_pair do |move, commands|
        commands.each do |command|
          it "should parse {command} and translate correctly" do
            translation = parser.parse(command)
            translation.should.not.be nil
            translation.eval.should.be.equal [command, "move #{move}"]
          end
        end
      end
    end

    describe 'macro' do
      {
        'G' => 'move to last line (end of file)',
        '3G' => 'move to line 3',
        'gg' => 'move to first line (beginning of file)',
        '15gg' => 'move to line 15'
      }.each_pair do |command, humanized|
        it "should parse #{command} and translate correctly" do
          translation = parser.parse(command)
          translation.should.not.be nil
          translation.eval.should.be.equal [command, humanized]
        end
      end
    end
  end
  
  describe 'normal mode commands' do
    it "should parse cwrandom blah>blah<blah<ES><ESC>" do
      #r = parser.parse("cwrandom blah>blah<blah<ES><ESC>")
      r = parser.parse("cwrandom blah>blah<blah<ES><ESC>")
      r.should.not.be nil
      r.eval.should == [
        ['cw', 'change word'],
        ['random blah>blah<blah<ES>', 'type random blah>blah<blah<ES>'],
        ['<ESC>', 'go to normal mode'],
      ]
    end

    it "should parse dw" do
      r = parser.parse("dw")
      r.should.not.be nil
      r.eval.should == [
        ['dw', 'delete word']
      ]
    end
   
    it "should parse daw" do
      r = parser.parse("daw")
      r.should.not.be nil
      r.eval.should == [
        ['daw', 'delete a word']
      ]
    end

    it "should parse d1w" do
      r = parser.parse("d1w")
      r.should.not.be nil
      r.eval.should == [
        ['d1w', 'delete 1 word']
      ]
    end

    it "should parse d2w" do
      r = parser.parse("d2w")
      r.should.not.be nil
      r.eval.should == [
        ['d2w', 'delete 2 words']
      ]
    end

    it "should parse diw" do
      r = parser.parse("diw")
      r.should.not.be nil
      r.eval.should == [
        ['diw', 'delete inner word']
      ]
    end

    it "should parse y(" do
      r = parser.parse("y(")
      r.should.not.be nil
      r.eval.should == [
        ['y(', 'yank sentence']
      ]
     end

     it "should parse 2dw" do
      r = parser.parse("2dw")
      r.should.not.be nil
      r.eval.should == [
        ['2',  '2 times: '],
        ['dw', 'delete word']
       ]
     end
     
     it "should parse 2dw2dw" do
      r = parser.parse("2dw2dw")
      r.should.not.be nil
      r.eval.should == [
          ['2',  '2 times: '],
          ['dw', 'delete word'],
          ['2',  '2 times: '],
          ['dw', 'delete word'],
      ]
     end
  end
 
  describe 'visual mode' do
    it "should parse v3wcabcde<ESC>" do
      r = parser.parse("v3wcabcde<ESC>")
      r.should.not.be nil
      r.eval.should == [
        ['v', 'go to visual mode'],
        ['3w', 'select 3 words'], 
        [
          ['c', 'change selection'], 
          ['abcde', 'type abcde'],
          ['<ESC>', 'go to normal mode']
          ]
      ]
    end
  end

   describe "command_mode" do
    it "should parse command mode with substitute" do
      r = parser.parse(":s/gogo/gaga<CR>")
      r.should.not.be nil
      r.eval.should == [
        [':', 'go to command mode'],
        ['s', 'substitute'], 
        ['/gogo', 'find gogo'], 
        ['/gaga', 'replace with gaga'],
        ['<CR>', 'execute command and go to normal mode']
      ]
    end

    [ 
      ["12,14", 'line 12 to line 14'] ,
      ["^,14", 'first line to line 14'] ,
      ["12,$", 'line 12 to last line'] ,
      ["12,.", 'line 12 to current line'] ,
      [".,+2", 'current line to the next 2 line(s)'] ,
      [".,-2", 'current line to the previous 2 line(s)'] ,
     ].each do |range, humanized|
      it "should parse :#{range}d<CR>" do
          r = parser.parse(":#{range}d<CR>")
          r.should.not.be nil
          r.eval.should == [
            [':', 'go to command mode'],
            [range, "select range: #{humanized}"], 
            ['d', 'delete range'], 
            ['<CR>', 'execute command and go to normal mode']
          ]
      end
    end
   end
end
