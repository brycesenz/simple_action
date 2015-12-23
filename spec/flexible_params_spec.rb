require 'spec_helper'
require 'fixtures/flexible_params_spec_class'

describe SimpleAction::Service do 
  describe "#run", run: true do
    context "with undefined params" do
      let(:outcome) { FlexibleParamsSpecClass.run(name: "Matthew", age: 12, weight: 150, height: "tall") }

      it "returns errors" do
        outcome.errors[:weight].should_not eq(["can't be blank"])
      end
    end
  end
end