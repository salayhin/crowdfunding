class AddIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :id, :integer
  end
end
