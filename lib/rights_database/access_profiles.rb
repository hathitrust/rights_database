# frozen_string_literal: true

module RightsDatabase
  class << self
    def access_profiles
      @access_profiles ||= AccessProfiles.new
    end
  end

  # Access Profile
  # Pulled from the access_profiles table.
  # A join when pulling an items rights would also work? (better)
  class AccessProfile
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
      name
    end
  end

  class AccessProfiles
    attr_accessor :profiles

    def initialize
      @profiles = load_from_db
    end

    # Look up profile by id or by name (which is less efficient since we don't have a map)
    def [](profile)
      if profile.is_a? String
        @profiles.find { |_k, v| v.name == profile }&.[](1) || unknown
      else
        @profiles[profile] || unknown
      end
    end

    private

    def load_from_db
      RightsDatabase.db[:access_profiles]
        .select(:id,
          :name,
          :dscr)
        .as_hash(:id)
        .transform_values { |h| AccessProfile.new(**h) }
    end

    def unknown
      @unknown ||= AccessProfile.new(id: nil, name: "unknown", dscr: "Not in rights database")
    end
  end
end
