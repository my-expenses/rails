class FixTypeColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :transactions, :type, :transactionType
  end
end
