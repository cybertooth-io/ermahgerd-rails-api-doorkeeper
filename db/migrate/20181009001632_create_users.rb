# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, index: true, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :nickname, null: true
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
