class CreateCards < ActiveRecord::Migration[7.1]
  def change
    create_table :cards, id: false do |t|
      t.string :id, primary_key: true
      t.string :user_id, null: false, index: true
      t.string :title

      t.timestamps
    end
  end
end
