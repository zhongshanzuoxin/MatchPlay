class CreateGroupTags < ActiveRecord::Migration[6.1]
  def change
    create_table :group_tags do |t|
      t.references :group, type: :bigint, foreign_key: true
      t.references :tag, type: :bigint, foreign_key: true

      t.timestamps
    end
    
    add_index :group_tags, [:group_id, :tag_id], unique: true
  end
end
