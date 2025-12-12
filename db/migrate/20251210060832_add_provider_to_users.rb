class AddProviderToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :provider, :string
  end
end
