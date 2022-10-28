# frozen_string_literal: true

RSpec.describe RightsDatabase::Attributes do
  let(:attributes) { RightsDatabase.attributes }

  it "can retrieve rights attributes" do
    expect(attributes).not_to be nil
  end

  it "can look up an attribute by id" do
    attribute = attributes[1]
    expect(attribute).to be_a(RightsDatabase::Attribute)
    expect(attribute.id).to be == 1
    expect(attribute.type).to be_a(String)
    expect(attribute.name).to be_a(String)
    expect(attribute.description).to be_a(String)
    expect(attribute.to_s).to eq(attribute.name)
  end

  it "can look up an attribute by name" do
    attribute = attributes["pd"]
    expect(attribute).to be_a(RightsDatabase::Attribute)
    expect(attribute.id).to be == 1
    expect(attribute.type).to be_a(String)
    expect(attribute.name).to be_a(String)
    expect(attribute.description).to be_a(String)
    expect(attribute.to_s).to eq(attribute.name)
  end

  it "can retrieve an unknown attribute" do
    attribute = attributes[999]
    expect(attribute).to be_a(RightsDatabase::Attribute)
    expect(attribute.id).to be nil
    expect(attribute.type).to be nil
    expect(attribute.name).to eq("unknown")
    expect(attribute.description).to be_a(String)
    expect(attribute.to_s).to eq(attribute.name)
  end
end
