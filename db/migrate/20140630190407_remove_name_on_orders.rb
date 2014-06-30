class RemoveNameOnOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :full_name
  end
end
