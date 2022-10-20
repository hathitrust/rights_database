# frozen_string_literal: true

RSpec.describe RightsDatabase::AccessProfiles do
  let(:profiles) { RightsDatabase.access_profiles }

  it "can retrieve access profiles" do
    expect(profiles).to be_a(RightsDatabase::AccessProfiles)
  end

  it "can look up an access profile by id" do
    profile = profiles[1]
    expect(profile).to be_a(RightsDatabase::AccessProfile)
    expect(profile.id).to be == 1
    expect(profile.name).to be_a(String)
    expect(profile.description).to be_a(String)
  end

  it "can look up an access profile by name" do
    profile = profiles["open"]
    expect(profile).to be_a(RightsDatabase::AccessProfile)
    expect(profile.id).to be_a(Integer)
    expect(profile.name).to eq("open")
    expect(profile.description).to be_a(String)
  end

  it "can retrieve an unknown access profile" do
    profile = profiles[999]
    expect(profile).to be_a(RightsDatabase::AccessProfile)
    expect(profile.id).to be nil
    expect(profile.name).to eq("unknown")
    expect(profile.description).to be_a(String)
  end
end
