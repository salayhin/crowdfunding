class RenameOrderDetailsTable < ActiveRecord::Migration
  def change
    rename_table :order_detail, :order_details
  end
end
