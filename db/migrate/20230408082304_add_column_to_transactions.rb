class AddColumnToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :account_id, :integer
  end
end
