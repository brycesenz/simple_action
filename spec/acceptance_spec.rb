require 'spec_helper'

describe "SimpleAction acceptance spec" do
  class SimpleActionAcceptance < SimpleAction::Service
    params do
      param :name, type: :string
      validate :name_has_vowels, if: :name

      def name_has_vowels
        unless name.scan(/[aeiou]/).count >= 1
          errors.add(:name, "must contain at least one vowel")
        end
      end
    end

    def execute
      name.upcase
    end
  end

  context "with nil params" do
    let(:params) do
      {
        name: nil
      }
    end

    describe "outcome" do
      subject { SimpleActionAcceptance.run(params) }

      it { should_not be_valid }
      it { should_not be_success }

      it "should have name error" do
        subject.errors[:name].should eq(["can't be blank"])
      end
    end

    describe "result" do
      subject { SimpleActionAcceptance.run(params).result }

      it { should be_nil }
    end
  end

  context "with invalid params" do
    let(:params) do
      {
        name: "sdfg"
      }
    end

    describe "outcome" do
      subject { SimpleActionAcceptance.run(params) }

      it { should_not be_valid }
      it { should_not be_success }

      it "should have name error" do
        subject.errors[:name].should eq(["must contain at least one vowel"])
      end
    end

    describe "result" do
      subject { SimpleActionAcceptance.run(params).result }

      it { should be_nil }
    end
  end

  context "with valid params" do
    let(:params) do
      {
        name: "billy"
      }
    end

    describe "outcome" do
      subject { SimpleActionAcceptance.run(params) }

      it { should be_valid }
      it { should be_success }
    end

    describe "result" do
      subject { SimpleActionAcceptance.run(params).result }

      it { should eq("BILLY") }
    end
  end
end
