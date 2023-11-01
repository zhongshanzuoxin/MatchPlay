class CreateGroupTags < ActiveRecord::Migration[6.1]
  def change
    create_table :group_tags do |t|
      t.integer :tag_id
      t.integer :group_id

      t.timestamps
    end
  end
end
