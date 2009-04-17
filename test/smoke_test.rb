require File.join(File.dirname(__FILE__), 'test_helper.rb')
parser = VimParser.new

#class Treetop::Runtime::SyntaxNode
#  def inspect
#    object_id.to_s + super
#  end
#end

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
