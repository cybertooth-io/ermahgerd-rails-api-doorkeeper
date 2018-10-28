class CreateSessionActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :session_activities do |t|
      t.datetime :created_at, null: false
      t.inet :ip_address, null: false
      t.string :path, null: false
      t.references :session, foreign_key: true, null: false
    end
  end
end
