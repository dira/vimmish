require File.join(File.dirname(__FILE__), 'test_helper.rb')
parser = VimParser.new

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
  end
end
