class CreateProfileIcons < ActiveRecord::Migration[6.1]
  def change
    create_table :profile_icons do |t|

      t.timestamps
    end
  end
end
