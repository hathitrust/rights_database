# frozen_string_literal: true

RSpec.describe RightsDatabase::AccessStatements do
  let(:statements) { RightsDatabase.access_statements }

  it "can retrieve access statements" do
    expect(statements).to be_a(RightsDatabase::AccessStatements)
  end

  it "can retrieve a particular access statement" do
    statement = statements["pd"]
    expect(statement).to be_a(RightsDatabase::AccessStatement)
    expect(statement.unknown?).to be false
    expect(statement.key).to eq("pd")
    expect(statement.url).to be_a(String)
    expect(statement.head).to be_a(String)
    expect(statement.text).to be_a(String)
    expect(statement.url_aux).to be_a(String).or be_nil
    expect(statement.icon).to be_a(String).or be_nil
    expect(statement.icon_aux).to be_a(String).or be_nil
    expect(statement.to_s).to eq(statement.key)
  end

  it "can retrieve an unknown access statement" do
    statement = statements["this statement does not exist"]
    expect(statement).to be_a(RightsDatabase::AccessStatement)
    expect(statement.unknown?).to be true
    expect(statement.key).to eq("unknown")
    expect(statement.head).to eq("Unknown")
    expect(statement.text).to be_a(String)
    expect(statement.to_s).to eq(statement.key)
  end
end
