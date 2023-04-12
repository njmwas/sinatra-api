class RemoveTypeOfLoanColumnFromTransactions < ActiveRecord::Migration[6.1]
  def change
    remove_column :transactions, :type_of_loan
  end
end
