class AddTxnReponsponseColumnToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :txn_response, :string
  end
end
