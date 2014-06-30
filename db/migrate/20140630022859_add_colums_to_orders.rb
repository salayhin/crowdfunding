class AddColumsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :stripe_charge_id, :string
    add_column :orders, :stripe_customer_id, :string
    add_column :orders, :card_last_4_digit, :integer
    add_column :orders, :card_brand, :string
    add_column :orders, :card_exp_month, :integer
    add_column :orders, :card_exp_year, :integer
    add_column :orders, :is_refunded, :boolean
    add_column :orders, :refund_amount, :float
  end
end
