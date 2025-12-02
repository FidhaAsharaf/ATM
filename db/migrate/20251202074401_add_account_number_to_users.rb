class AddAccountNumberToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :account_number, :string
  end
end
