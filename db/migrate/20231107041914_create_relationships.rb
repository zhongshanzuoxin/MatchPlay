class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :blocked_id 
      t.integer :blocking_id 

      t.timestamps
    end
  end
end
