class CreateBlockUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :block_users do |t|
      t.references :blocker, foreign_key: { to_table: :users }
      t.references :blocked, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
