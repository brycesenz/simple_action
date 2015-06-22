require 'spec_helper'
require 'fixtures/service_spec_class'

describe SimpleAction::Service do
  describe "class_methods", class_methods: true do
    describe "#model_name", model_name: true do
      it "has correct model name" do
        ServiceSpecClass.model_name.should eq("ServiceSpecClass")
      end
    end

    describe "#run", run: true do
      context "with invalid attributes" do
        let(:outcome) { ServiceSpecClass.run(age: 12) }

        it "is not valid?" do
          outcome.should_not be_valid
        end

        it "is not success?" do
          outcome.should_not be_success
        end

        it "has no result" do
          outcome.result.should eq(nil)
        end

        it "returns errors" do
          outcome.errors[:name].should eq(["can't be blank"])
        end
      end

      context "with valid attributes" do
        let(:outcome) { ServiceSpecClass.run(name: "David", age: 12) }

        it "is valid?" do
          outcome.should be_valid
        end

        it "is success?" do
          outcome.should be_success
        end

        it "has result equal to output of execute" do
          outcome.result.should eq(41)
        end

        it "returns empty errors" do
          outcome.errors.should be_empty
        end
      end
    end

    describe "#run!", run!: true do
      context "with invalid attributes" do
        it "raises error" do
          expect { ServiceSpecClass.run!(age: 12) }.to raise_error(StandardError,
            "Name can't be blank"
          )
        end
      end

      context "with valid attributes" do
        let(:outcome) { ServiceSpecClass.run!(name: "David", age: 12) }

        it "is equal to the output of execute" do
          outcome.should eq(41)
        end
      end
    end

    describe "#api_pie_documentation", api_pie_documentation: true do
      it "equals params api_pie_documentation" do
        ServiceSpecClass.api_pie_documentation.should eq("param :name, String, desc: '', required: true\nparam :age, Integer, desc: '', required: false")
      end
    end
  end

  describe "instance methods", instance_methods: true do
    describe "#to_key", to_key: true do
      it "has correct keys" do
        params = ServiceSpecClass.new(name: "Tom", age: 12)
        params.to_key.should be_nil
      end
    end

    describe "#params", params: true do
      it "assigns params" do
        instance = ServiceSpecClass.new(name: "Nic Cage", age: "40")
        instance.params.name.should eq("Nic Cage")
        instance.params.age.should eq(40)
      end
    end

    describe "#valid?", valid: true do
      context "with invalid params" do
        it "is false" do
          ServiceSpecClass.new(age: 12).should_not be_valid
        end
      end

      context "with valid params" do
        it "is true" do
          ServiceSpecClass.new(name: "Tom", age: 12).should be_valid
        end
      end
    end

    describe "#errors", errors: true do
      context "with invalid params" do
        let(:instance) { ServiceSpecClass.new(age: 12) }

        it "is empty before validation" do
          instance.errors.should be_empty
        end

        it "returns errors with correct messages" do
          instance.valid?
          instance.errors.should_not be_empty
          instance.errors[:name].should eq(["can't be blank"])
        end
      end

      context "with valid params" do
        let(:instance) { ServiceSpecClass.new(age: 12, name: "Tom") }

        it "is empty before validation" do
          instance.errors.should be_empty
        end

        it "is empty after validation" do
          instance.valid?
          instance.errors.should be_empty
        end
      end
    end
  end
end
