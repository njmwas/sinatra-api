class AddTxnStatusToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :txn_status, :string
  end
end
