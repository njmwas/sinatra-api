class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.float :amount
      t.string :type_of_loan
      t.string :type
      t.string :trx_ref
      t.text  :narative
    end
  end
end
