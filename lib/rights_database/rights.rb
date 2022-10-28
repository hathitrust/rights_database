# frozen_string_literal: true

module RightsDatabase
  # Rights for an individual HT item
  class Rights
    attr_accessor :item_id, :attribute, :reason, :source, :time, :note, :access_profile, :user, :namespace, :id

    def initialize(item_id:)
      @item_id = item_id
      @namespace, @id = @item_id.split(/\./, 2)
      load_from_db
    end

    def to_s
      "#{@attribute}/#{@reason}"
    end

    private

    def load_from_db
      rights = RightsDatabase.db[:rights_current]
        .where(:namespace => namespace, Sequel.qualify(:rights_current, :id) => id)
        .first || unknown_rights
      rights.each do |k, v|
        case k
        when :attr
          @attribute = RightsDatabase.attributes[v]
        when :reason
          @reason = RightsDatabase.reasons[v]
        when :access_profile
          @access_profile = RightsDatabase.access_profiles[v]
        when :source
          @source = RightsDatabase.sources[v]
        else
          public_send("#{k}=", v)
        end
      end
    end

    # null object for items missing rights
    def unknown_rights
      {
        namespace: namespace,
        id: id,
        attr: nil,
        reason: nil,
        source: nil,
        time: nil,
        note: "Item not in rights database",
        access_profile: nil,
        user: nil
      }.freeze
    end
  end
end
