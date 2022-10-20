# frozen_string_literal: true

module RightsDatabase
  class << self
    def reasons
      @reasons ||= Reasons.new
    end
  end

  # Reason description
  class Reason
    attr_reader :id, :name, :description

    def initialize(id:, name:, dscr:)
      @id = id
      @name = name
      @description = dscr
    end

    def unknown?
      @id.nil?
    end

    def to_s
      @name
    end
  end

  class Reasons
    attr_accessor :reasons

    def initialize
      @reasons ||= load_from_db
    end

    # Look up reason by id or by name (which is less efficient)
    def [](reason)
      if reason.is_a? String
        @reasons.find { |_k, v| v.name == reason }&.[](1) || unknown
      else
        @reasons[reason] || unknown
      end
    end

    private

    def load_from_db
      RightsDatabase.db[:reasons]
        .select(:id,
          :name,
          :dscr)
        .as_hash(:id)
        .transform_values { |h| Reason.new(**h) }
    end

    def unknown
      @unknown ||= Reason.new(id: nil, name: "unknown", dscr: "Not in rights database")
    end
  end
end
