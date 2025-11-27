class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :previous_balance
      t.integer :amount
      t.integer :new_balance
      t.string :transaction_type

      t.timestamps
    end
  end
end
