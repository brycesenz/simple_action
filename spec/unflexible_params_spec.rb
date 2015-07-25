require 'spec_helper'
require 'fixtures/unflexible_params_spec_class'

describe SimpleAction::Service do 
    describe "#run!", run!: true do
      context "with undefined params" do
        it "raises error" do
          expect { UnflexibleParamsSpecClass.run!(name: "Matthew", age: 36, weight: 220) }.to raise_error(SimpleParamsError,
            "parameter weight= is not defined."
          )
        end
    end
  end
end