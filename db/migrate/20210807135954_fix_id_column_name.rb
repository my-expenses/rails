class FixIdColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :transactions, :id, :ID
    rename_column :categories, :id, :ID
  end
end
