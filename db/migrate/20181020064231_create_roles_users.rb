class CreateRolesUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :roles_users do |t|
      t.references :role, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
    end
  end
end
