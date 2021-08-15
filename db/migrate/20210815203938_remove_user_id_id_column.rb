class RemoveUserIdIdColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :transactions, :user_id_id
  end
end
