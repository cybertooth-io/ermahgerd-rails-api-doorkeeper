# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.string :browser, null: false
      t.string :browser_version, null: false
      t.string :device, null: false
      t.datetime :expiring_at, null: false
      t.boolean :invalidated, default: false, null: false
      t.references :invalidated_by, foreign_key: { to_table: :users }, index: true, null: true
      t.inet :ip_address, null: false
      t.string :platform, null: false
      t.string :platform_version, null: false
      t.string :ruid, null: false, index: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
