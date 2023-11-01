class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :visiter_id
      t.integer :visited_id
      t.integer :user_id
      t.integer :action

      t.timestamps
    end
  end
end
