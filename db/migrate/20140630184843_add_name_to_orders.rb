class AddNameToOrders < ActiveRecord::Migration
  def change
    add_column :orders,:full_name, :string
    add_column :orders, :is_paid, :boolean
  end
end
