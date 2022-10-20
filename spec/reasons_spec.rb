# frozen_string_literal: true

RSpec.describe RightsDatabase::Reasons do
  let(:reasons) { RightsDatabase.reasons }

  it "can retrieve rights reasons" do
    expect(reasons).not_to be nil
  end

  it "can look up a reason by id" do
    reason = reasons[1]
    expect(reason).to be_a(RightsDatabase::Reason)
    expect(reason.id).to be == 1
    expect(reason.name).to be_a(String)
    expect(reason.description).to be_a(String)
    expect(reason.to_s).to eq(reason.name)
  end

  it "can look up a reason by name" do
    reason = reasons["bib"]
    expect(reason).to be_a(RightsDatabase::Reason)
    expect(reason.id).to be == 1
    expect(reason.name).to eq("bib")
    expect(reason.description).to be_a(String)
    expect(reason.to_s).to eq(reason.name)
  end

  it "can retrieve an unknown reason" do
    reason = reasons[999]
    expect(reason).to be_a(RightsDatabase::Reason)
    expect(reason.id).to be nil
    expect(reason.name).to eq("unknown")
    expect(reason.description).to be_a(String)
    expect(reason.to_s).to eq(reason.name)
  end
end
