require File.join(File.dirname(__FILE__), 'test_helper.rb')
parser = Vimmish.parser

describe "smoke tests" do
  ["d", "y"].each do |command|
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
