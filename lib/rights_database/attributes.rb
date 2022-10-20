# frozen_string_literal: true

module RightsDatabase
  class << self
    def attributes
      @attributes ||= Attributes.new
    end
  end

  class Attribute
    attr_reader :id, :type, :name, :description

    def initialize(id:, type:, name:, dscr:)
      @id = id
      @type = type
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

  # Rights Attributes
  class Attributes
    attr_accessor :attributes

    def initialize
      @attributes ||= load_from_db
    end

    # Look up attr by id or by name (which is less efficient since we don't have a map)
    def [](attr)
      if attr.is_a? String
        @attributes.find { |_k, v| v.name == attr }&.[](1) || unknown
      else
        @attributes[attr] || unknown
      end
    end

    private

    def load_from_db
      RightsDatabase.db[:attributes]
        .select(:id,
          :type,
          :name,
          :dscr)
        .as_hash(:id)
        .transform_values { |h| Attribute.new(**h) }
    end

    def unknown
      @unknown ||= Attribute.new(id: nil, type: nil, name: "unknown", dscr: "Not in rights database")
    end
  end
end
