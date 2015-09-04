require 'spec_helper'

describe "SimpleAction acceptance spec" do
  class SimpleActionAcceptance < SimpleAction::Service
    params do
      param :name, type: :string
      param :date_of_birth, type: :date, optional: true
      validate :name_has_vowels, if: :name

      nested_hash :address, optional: true do
        param :street, optional: true
      end

      nested_array :phones, with_ids: true do
        param :phone_number
      end

      def name_has_vowels
        unless name.scan(/[aeiou]/).count >= 1
          errors.add(:name, "must contain at least one vowel")
        end
      end
    end

    def execute
      name.gsub!(/[^a-zA-Z ]/,'')
      if name == "outlier"
        errors.add(:name, "can't be outlier")
      elsif date_of_birth.present?
        name.upcase + ' ' + date_of_birth.strftime("%m/%d/%Y")
      else
        name.upcase
      end
    end
  end

  describe "#model_name", model_name: true do
    it "equals class name" do
      SimpleActionAcceptance.model_name.should eq("SimpleActionAcceptance")
    end
  end

  describe "params #model_name", params_model_name: true do
    it "equals class name::Params" do
      SimpleActionAcceptance.new.params.model_name.should eq("SimpleActionAcceptance::SimpleActionAcceptanceParams")
    end
  end

  describe "params accessors", params: true do
    let(:instance) { SimpleActionAcceptance.new }

    it "allows setters and getters on param vars" do
      instance.name = "Bob"
      expect(instance.name).to eq("Bob")
    end

    it "allows setters and getters on nested_hash" do
      instance.address = { street: "1 Main St." }
      expect(instance.address.street).to eq("1 Main St.")
    end

    it "allows setters and getters on nested_hash using _attributes" do
      instance.address_attributes = { street: "1 Main St." }
      expect(instance.address.street).to eq("1 Main St.")
    end

    it "responds to build_ methods" do
      address = instance.build_address
      address.class.name.should eq("SimpleActionAcceptance::SimpleActionAcceptanceParams::Address")
    end
  end

  describe "class methods", class_methods: true do
    describe "reflect_on_association", reflect_on_association: true do
      it "returns Address class for :address" do
        address_klass = SimpleActionAcceptance.reflect_on_association(:address)
        address_klass.klass.should eq(SimpleActionAcceptance::SimpleActionAcceptanceParams::Address)
      end
    end
  end

  describe "outcome" do
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

      describe "effects" do
      end
    end

    context "with invalid params" do
      let!(:name) { "sdfg" }

      let(:params) do
        {
          name: name
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

      describe "effects" do
        it "does not alter name" do
          SimpleActionAcceptance.run(params)
          name.should eq("sdfg")
        end
      end
    end

    context "with valid params" do
      let!(:name) { "billy12" }

      let(:params) do
        {
          name: name,
          phones: [
            "0" => {
              phone_number: "8005551212"
            }
          ]
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

      describe "effects" do
        it "strips numbers from name" do
          SimpleActionAcceptance.run(params)
          name.should eq("billy")
        end
      end
    end

    context "with date coercion params" do
      let!(:name) { "billy12" }

      let(:params) do
        {
          name: name,
          "date_of_birth(3i)" => "5",
          "date_of_birth(2i)" => "6",
          "date_of_birth(1i)" => "1984",
          phones: [
            "0" => {
              phone_number: "8005551212"
            }
          ]
        }
      end

      describe "outcome" do
        subject { SimpleActionAcceptance.run(params) }

        it { should be_valid }
        it { should be_success }
      end

      describe "result" do
        subject { SimpleActionAcceptance.run(params).result }

        it { should eq("BILLY 06/05/1984") }
      end

      describe "effects" do
        it "strips numbers from name" do
          SimpleActionAcceptance.run(params)
          name.should eq("billy")
        end
      end
    end

    context "with outlier case" do
      let!(:name) { "outlier12" }

      let(:params) do
        {
          name: name,
          phones: [
            "0" => {
              phone_number: "8005551212"
            }
          ]
        }
      end

      describe "outcome" do
        subject { SimpleActionAcceptance.run(params) }

        it { should_not be_valid }
        it { should_not be_success }

        it "should have name error" do
          subject.errors[:name].should eq(["can't be outlier"])
        end
      end

      describe "result" do
        subject { SimpleActionAcceptance.run(params).result }

        it { should be_nil }
      end

      describe "effects" do
        it "alter names" do
          SimpleActionAcceptance.run(params)
          name.should eq("outlier")
        end
      end
    end
  end
end
