# frozen_string_literal: true

# A Sidekiq Worker that will create a `SessionActivity` record.
class RecordSessionActivityWorker
  include Sidekiq::Worker

  def perform(created_at_iso8601, ip_address, path, session_id)
    SessionActivity.create!(
      created_at: Time.zone.parse(created_at_iso8601),
      ip_address: ip_address,
      path: path,
      session_id: session_id
    )
  end
end
