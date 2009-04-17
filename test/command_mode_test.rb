require File.join(File.dirname(__FILE__), 'test_helper.rb')
parser = Vimmish.parser

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
