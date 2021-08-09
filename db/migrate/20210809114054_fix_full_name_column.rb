class FixFullNameColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :full_name, :fullName
  end
end
