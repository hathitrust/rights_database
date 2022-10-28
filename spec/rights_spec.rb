# frozen_string_literal: true

RSpec.describe RightsDatabase::Rights do
  shared_examples "Rights" do
    ["item_id", "namespace", "id"].each do |field|
      it "has a non-nil #{field} field" do
        expect(subject.public_send(field)).not_to be nil
      end
    end
  end

  context "known item" do
    shared_examples "known item Rights" do
      it "has a RightsDatabase::Attribute attribute" do
        expect(subject.attribute).to be_a(RightsDatabase::Attribute)
      end

      it "has a RightsDatabase::Reason reason" do
        expect(subject.reason).to be_a(RightsDatabase::Reason)
      end

      it "has a RightsDatabase::Source source" do
        expect(subject.source).to be_a(RightsDatabase::Source)
      end

      it "has a RightsDatabase::AccessProfile access_profile" do
        expect(subject.access_profile).to be_a(RightsDatabase::AccessProfile)
      end

      ["user", "time"].each do |field|
        it "has a non-nil #{field} field" do
          expect(subject.public_send(field)).not_to be nil
        end
      end

      ["note"].each do |field|
        it "has a String or nil #{field} field" do
          expect(subject.public_send(field)).to be(nil).or be_a(String)
        end
      end
    end

    subject { RightsDatabase::Rights.new(item_id: "test.pd_open") }
    it_behaves_like "Rights"
    it_behaves_like "known item Rights"

    it "has a string value concatenated from attribute and reason" do
      expect(subject.to_s).to eq("pd/bib")
    end
  end

  context "unknown item" do
    shared_examples "unknown item Rights" do
      ["user", "time"].each do |field|
        it "has a nil #{field} field" do
          expect(subject.public_send(field)).to be nil
        end
      end

      ["attribute", "reason", "source", "access_profile"].each do |field|
        it "has an unknown #{field} field" do
          expect(subject.public_send(field).unknown?).to be true
        end
      end

      it "has a note string" do
        expect(subject.note).to be_a(String)
      end
    end

    subject { RightsDatabase::Rights.new(item_id: "bogus.does_not_exist") }
    it_behaves_like "Rights"
    it_behaves_like "unknown item Rights"

    it "has a string value concatenated from attribute and reason" do
      expect(subject.to_s).to eq("unknown/unknown")
    end
  end
end
