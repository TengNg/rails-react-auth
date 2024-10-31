class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: false do |t|
      t.string :id, primary_key: true
      t.string :username
      t.string :password
      t.integer :refresh_token_version, default: 0

      t.timestamps
    end
  end
end
