require 'spec_helper'
require 'fixtures/dummy_service_object_class'

describe SimpleAction::Response do
  describe "#valid?" do
    context "with valid object" do
      let(:object) { DummyServiceObjectClass.new(name: "Dummy") }
      let(:response) { described_class.new(object) }

      it "is valid" do
        response.should be_valid
      end
    end

    context "with invalid object" do
      let(:object) { DummyServiceObjectClass.new(name: nil) }
      let(:response) { described_class.new(object) }

      it "is not valid" do
        response.should_not be_valid
      end
    end
  end

  describe "#errors" do
    context "with valid object" do
      let(:object) { DummyServiceObjectClass.new(name: "Dummy") }
      let(:response) { described_class.new(object) }

      it "has no errors" do
        response.errors.should be_empty
      end
    end

    context "with invalid object" do
      let(:object) { DummyServiceObjectClass.new(name: nil) }
      let(:response) { described_class.new(object) }

      it "has errors" do
        response.errors[:name].should eq(["can't be blank"])
      end
    end
  end

  describe "#success?" do
    context "with valid object" do
      let(:object) { DummyServiceObjectClass.new(name: "Dummy") }
      let(:response) { described_class.new(object) }

      it "is success" do
        response.should be_success
      end
    end

    context "with invalid object" do
      let(:object) { DummyServiceObjectClass.new(name: nil) }
      let(:response) { described_class.new(object) }

      it "is not success" do
        response.should_not be_success
      end
    end
  end

  describe "#result" do
    let(:object) { DummyServiceObjectClass.new(name: "Dummy") }

    context "with no result provided" do
      let(:response) { described_class.new(object) }

      it "is nil" do
        response.result.should be_nil
      end
    end

    context "with response provided" do
      let(:response) { described_class.new(object, 53) }

      it "is 53" do
        response.result.should eq(53)
      end
    end
  end
end
