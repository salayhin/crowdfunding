class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :order_id
      t.float :order_total
      t.string :stripe_charge_id
      t.string :stripe_customer_id
      t.string :card_last_4_digit
      t.string :card_brand
      t.string :card_exp_month
      t.string :card_exp_year
      t.boolean :is_refunded
      t.float :refund_amount
      t.boolean :is_paid

      t.timestamps
    end
  end
end
