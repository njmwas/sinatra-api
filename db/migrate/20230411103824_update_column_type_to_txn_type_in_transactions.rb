class UpdateColumnTypeToTxnTypeInTransactions < ActiveRecord::Migration[6.1]
  def change
    remove_column :transactions, :type
    add_column :transactions, :txn_type, :string
  end
end
