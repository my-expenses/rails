class FixTransactionTitleColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :transactions, :title, :transactionTitle
  end
end
