class RenamePaymentOptionTable < ActiveRecord::Migration
  def change
    rename_table :payment_options, :products
  end
end
