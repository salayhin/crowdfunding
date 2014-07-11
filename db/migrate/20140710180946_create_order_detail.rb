class CreateOrderDetail < ActiveRecord::Migration
  def change
    create_table :order_detail do |t|

      t.timestamps
    end
  end
end
