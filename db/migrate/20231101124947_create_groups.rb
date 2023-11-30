class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.text :introduction
      t.text :game_title, null: false
      t.bigint :owner_id, null: false
      t.integer :max_users, null: false

      t.timestamps
    end

    add_foreign_key :groups, :users, column: :owner_id
  end
end
