class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.text :introduction
      t.integer :owner_id
      t.string :game_title
      t.string :tag

      t.timestamps
    end
  end
end
