class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.text :introduction
      t.references :user, foreign_key: true
      t.string :game_title
      t.string :tag

      t.timestamps
    end
  end
end
