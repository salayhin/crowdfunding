class RenameOrderUidToOrderId < ActiveRecord::Migration
  def change
    rename_column :order_details, :order_uid, :order_id
  end
end
