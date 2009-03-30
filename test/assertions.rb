module Assertions
  class ParseTo < Test::Spec::CustomShould
    def initialize(parser, result)
      @parser = parser
      @result = result
    end
    def assumptions(object)
      r = @parser.parse(object)

      r.should.not.be nil
      r.eval.should.equal @result
    end
  end

  def parse_to(parser, result)
    ParseTo.new(parser, result)
  end
end
