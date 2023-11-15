class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :content
      t.boolean :read, null: false, default: "false"

      t.timestamps
    end
  end
end
