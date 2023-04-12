class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :member_id
      t.string :member_status
      t.integer :user_id
    end
  end
end
