class CreateUsersRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :users_roles do |t|
      t.string :user_id, null: false, index: true
      t.string :role_id, null: false, index: true

      t.timestamps
    end
  end
end
