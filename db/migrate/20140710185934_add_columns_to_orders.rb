class AddColumnsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :email, :string
    add_column :orders, :billing_full_name, :string
    add_column :orders, :billing_email, :string
    add_column :orders, :billing_address1, :string
    add_column :orders, :billing_address2, :string
    add_column :orders, :billing_city, :string
    add_column :orders, :billing_state,:string
    add_column :orders, :billing_zip, :string
    add_column :orders, :billing_country, :string
  end
end
