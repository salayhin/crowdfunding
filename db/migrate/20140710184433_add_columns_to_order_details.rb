class AddColumnsToOrderDetails < ActiveRecord::Migration
  def change
    add_column :order_detail, :payment_option_id, :integer
    add_column :order_detail, :order_uid, :string
  end
end
