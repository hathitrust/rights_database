# frozen_string_literal: true

RSpec.describe RightsDatabase::Sources do
  let(:sources) { RightsDatabase.sources }

  it "can retrieve rights sources" do
    expect(sources).not_to be nil
  end

  shared_examples "Source" do
    it "is a RightsDatabase::Source" do
      expect(subject).to be_a(RightsDatabase::Source)
    end

    it "has a name String" do
      expect(subject.name).to be_a(String)
    end

    it "has a description String" do
      expect(subject.description).to be_a(String)
    end

    it "has a known AccessProfile" do
      expect(subject.access_profile).to be_a(RightsDatabase::AccessProfile)
      expect(subject.access_profile.unknown?).to be false
    end

    it "has a digitization source" do
      expect(subject.digitization_source).to be_a(String)
    end

    it "is stringified as its name" do
      expect(subject.to_s).to eq(subject.name)
    end

    it "is not unknown" do
      expect(subject.unknown?).to be false
    end
  end

  describe "#[] by id" do
    subject { sources[1] }
    it_behaves_like "Source"
  end

  describe "#[] by name" do
    subject { sources["umich"] }
    it_behaves_like "Source"
  end

  it "can retrieve an unknown source" do
    source = sources[999]
    expect(source).to be_a(RightsDatabase::Source)
    expect(source.id).to be nil
    expect(source.name).to eq("unknown")
    expect(source.description).to be_a(String)
    expect(source.access_profile).to be_a(RightsDatabase::AccessProfile)
    expect(source.access_profile.unknown?).to be true
    expect(source.digitization_source).to be nil
    expect(source.to_s).to eq(source.name)
  end
end
