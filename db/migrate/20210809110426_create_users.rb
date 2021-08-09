class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :full_name
      t.string :password_digest
      t.boolean :email_verified

      t.timestamps
    end
  end
end
