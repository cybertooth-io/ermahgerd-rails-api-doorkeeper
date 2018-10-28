class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :key, null: false, index: {unique: true}
      t.string :name, null: false
      t.text :notes, null: true

      t.timestamps
    end
  end
end
