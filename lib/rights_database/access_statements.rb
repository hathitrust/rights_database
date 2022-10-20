# frozen_string_literal: true

module RightsDatabase
  class << self
    def access_statements
      @access_statements ||= AccessStatements.new
    end
  end

  # Access Statement
  # Pulled from the access_profiles table.
  class AccessStatement
    attr_reader :key, :url, :head, :text, :url_aux, :icon, :icon_aux

    def initialize(stmt_key:, stmt_url:, stmt_head:, stmt_text:, stmt_url_aux:,
      stmt_icon:, stmt_icon_aux:)
      @key = stmt_key
      @url = stmt_url
      @head = stmt_head
      @text = stmt_text
      @url_aux = stmt_url_aux
      @icon = stmt_icon
      @icon_aux = stmt_icon_aux
    end

    def unknown?
      @key == "unknown"
    end

    def to_s
      @key
    end
  end

  class AccessStatements
    attr_accessor :statements

    def initialize
      @statements = load_from_db
    end

    def [](key)
      @statements[key] || unknown
    end

    def unknown
      @unknown ||= AccessStatement.new(stmt_key: "unknown", stmt_url: nil,
        stmt_head: "Unknown", stmt_text: "Not in rights database",
        stmt_url_aux: nil, stmt_icon: nil, stmt_icon_aux: nil)
    end

    private

    def load_from_db
      RightsDatabase.db[:access_stmts]
        .select(:stmt_key,
          :stmt_url,
          :stmt_head,
          :stmt_text,
          :stmt_url_aux,
          :stmt_icon,
          :stmt_icon_aux)
        .as_hash(:stmt_key)
        .transform_values { |h| AccessStatement.new(**h) }
    end
  end
end
