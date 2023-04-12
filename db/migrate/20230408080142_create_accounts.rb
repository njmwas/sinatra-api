class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.integer :member_id
      t.integer :total_savings
    end
  end
end
