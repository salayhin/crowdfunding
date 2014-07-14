class AddMoreColumnsToOrderDetails < ActiveRecord::Migration
  def change
    add_column :order_detail, :price, :float
    add_column :order_detail, :quantity, :integer
  end
end
