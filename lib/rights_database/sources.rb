# frozen_string_literal: true

module RightsDatabase
  class << self
    def sources
      @sources ||= Sources.new
    end
  end

  class Source
    attr_reader :id, :name, :description, :access_profile, :digitization_source

    def initialize(id:, name:, dscr:, access_profile:, digitization_source:)
      @id = id
      @name = name
      @description = dscr
      @access_profile = AccessProfiles.new[access_profile]
      @digitization_source = digitization_source
    end

    def unknown?
      @id.nil?
    end

    def to_s
      @name
    end
  end

  # Rights Attributes
  class Sources
    attr_accessor :sources

    def initialize
      @sources ||= load_from_db
    end

    def [](source)
      if source.is_a? String
        @sources.find { |_k, v| v.name == source }&.[](1) || unknown
      else
        @sources[source] || unknown
      end
    end

    private

    def load_from_db
      RightsDatabase.db[:sources]
        .select(:id,
          :name,
          :dscr,
          :access_profile,
          :digitization_source)
        .as_hash(:id)
        .transform_values { |h| Source.new(**h) }
    end

    def unknown
      @unknown ||= Source.new(id: nil, name: "unknown", dscr: "Not in rights database",
        access_profile: nil, digitization_source: nil)
    end
  end
end
