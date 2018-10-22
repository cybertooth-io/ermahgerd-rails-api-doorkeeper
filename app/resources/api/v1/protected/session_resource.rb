# frozen_string_literal: true

module Api
  module V1
    module Protected
      # Protected access to the `Session` model.
      # Note that the RUID is not ever exposed or sent to through the wire.
      class SessionResource < JSONAPI::Resource
        immutable # no CUD through controller

        # Attributes
        # --------------------------------------------------------------------------------------------------------------

        # Notice that we're not serializing the RUID column; keep that hidden to the public
        attributes(
          :browser,
          :browser_version,
          :created_at,
          :device,
          :expiring_at,
          :invalidated,
          :ip_address,
          :platform,
          :platform_version,
          :updated_at,
          {}
        )

        # Relationships
        # --------------------------------------------------------------------------------------------------------------

        has_one :invalidated_by

        has_one :user
      end
    end
  end
end
