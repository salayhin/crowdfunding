class ChangeUserFormatInOrderTable < ActiveRecord::Migration
  def change
    change_column :orders, :user_id, 'integer USING CAST(user_id AS integer)'
  end
end
