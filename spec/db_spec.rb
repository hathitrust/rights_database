# frozen_string_literal: true

RSpec.describe RightsDatabase::DB do
  it "can connect to DB with built-in connection string" do
    expect(RightsDatabase.db).not_to be nil
  end

  it "can connect to DB with explicit connection string" do
    expect(RightsDatabase.connect(ENV["RIGHTS_DATABASE_CONNECTION_STRING"])).not_to be nil
  end

  it "can connect to DB with connection arguments" do
    ENV.with(RIGHTS_DATABASE_CONNECTION_STRING: nil) do
      args = {user: "ht_rights", password: "ht_rights", host: "mariadb",
              database: "ht", adapter: "mysql2"}
      expect(RightsDatabase.connect(**args)).not_to be nil
    end
  end

  it "can connect to DB with connection ENV variables" do
    env = {RIGHTS_DATABASE_CONNECTION_STRING: nil,
           RIGHTS_DATABASE_USER: "ht_rights",
           RIGHTS_DATABASE_PASSWORD: "ht_rights",
           RIGHTS_DATABASE_HOST: "mariadb",
           RIGHTS_DATABASE_DATABASE: "ht",
           RIGHTS_DATABASE_ADAPTER: "mysql2"}
    ENV.with(**env) do
      expect(RightsDatabase.connect).not_to be nil
    end
  end
end
