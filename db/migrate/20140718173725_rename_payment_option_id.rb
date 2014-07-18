class RenamePaymentOptionId < ActiveRecord::Migration
  def change
    rename_column :order_details, :payment_option_id, :product_id
  end
end
