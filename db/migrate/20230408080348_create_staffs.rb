class CreateStaffs < ActiveRecord::Migration[6.1]
  def change
    create_table :staffs do |t|
      t.string :staff_id
      t.string :role
      t.integer :user_id
    end
  end
end
