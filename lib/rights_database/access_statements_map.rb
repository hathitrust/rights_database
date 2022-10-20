# frozen_string_literal: true

module RightsDatabase
  class << self
    def access_statements_map
      @access_statements_map ||= AccessStatementsMap.new
    end
  end

  # Access Statement Map
  # Maps attributes.name and access_profiles.name to access_stmts.stmt_key
  class AccessStatementsMap
    attr_accessor :map

    def initialize
      @map = load_from_db
    end

    # Look up access statement by Attribute and Access Profile.
    # Either can be the corresponding object or object name
    def [](attribute:, access_profile:)
      @map[[attribute.to_s, access_profile.to_s]] || RightsDatabase.access_statements.unknown
    end

    def for(rights:)
      @map[[rights.attribute.to_s, rights.access_profile.to_s]] || RightsDatabase.access_statements.unknown
    end

    private

    def load_from_db
      RightsDatabase.db[:access_stmts_map]
        .select(:a_attr,
          :a_access_profile,
          :stmt_key)
        .as_hash([:a_attr, :a_access_profile], :stmt_key)
        .transform_values { |stmt_key| RightsDatabase.access_statements[stmt_key] }
    end
  end
end
