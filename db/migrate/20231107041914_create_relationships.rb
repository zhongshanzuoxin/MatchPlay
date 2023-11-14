class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.references :blocked, null: false, foreign_key: { to_table: :users }
      t.references :blocking, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :relationships, [:blocked_id, :blocking_id], unique: true
  end
end

