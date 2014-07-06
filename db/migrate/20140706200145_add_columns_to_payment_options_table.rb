class AddColumnsToPaymentOptionsTable < ActiveRecord::Migration
  def change
    add_column :payment_options, :title, :string, after: :id
    add_column :payment_options, :is_published, :boolean
  end
end
