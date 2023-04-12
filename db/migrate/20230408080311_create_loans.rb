class CreateLoans < ActiveRecord::Migration[6.1]
  def change
    create_table :loans do |t|
      t.float :amount
      t.float :integer
      t.float :balance
      t.datetime :due_date
      t.integer :type_of_loan
    end
  end
end
