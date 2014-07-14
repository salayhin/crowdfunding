class AddColumnsToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :stripe_charge, :float
  end
end
