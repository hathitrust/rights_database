# frozen_string_literal: true

RSpec.describe RightsDatabase::AccessStatementsMap do
  let(:map) { RightsDatabase.access_statements_map }

  it "can retrieve access statements map" do
    expect(map).to be_a(RightsDatabase::AccessStatementsMap)
  end

  it "can retrieve a particular access statement with attribute and profile names" do
    statement = map[attribute: "pd", access_profile: "open"]
    expect(statement).to be_a(RightsDatabase::AccessStatement)
  end

  it "can retrieve a particular access statement with attribute and profile objects" do
    statement = map[attribute: RightsDatabase.attributes["pd"],
      access_profile: RightsDatabase.access_profiles["open"]]
    expect(statement).to be_a(RightsDatabase::AccessStatement)
    expect(statement.key).to eq("pd")
  end

  it "can retrieve a particular access statement with rights" do
    rights = RightsDatabase::Rights.new(item_id: "test.pd_open")
    statement = map.for(rights: rights)
    expect(statement).to be_a(RightsDatabase::AccessStatement)
    expect(statement.key).to eq("pd")
  end

  it "fails to retrieve an unknown access statement" do
    statement = map[attribute: "invalid attr", access_profile: "invalid profile"]
    expect(statement).to be_a(RightsDatabase::AccessStatement)
    expect(statement.key).to eq("unknown")
    expect(statement.head).to eq("Unknown")
  end
end
