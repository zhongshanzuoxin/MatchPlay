class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.integer :group_id
      t.integer :user_id
      t.text :message

      t.timestamps
    end
  end
end
