class FixCategoryIdColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :transactions, :category_id, :categoryID
  end
end
