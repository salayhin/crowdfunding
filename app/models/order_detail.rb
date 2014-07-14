class OrderDetail < ActiveRecord::Base
  belongs_to :order
  belongs_to :payment_option

  # (+quantity) add quantity, (-quantity) remove quantity
  def change_quantity(quantity)
    self.limit = self.limit + quantity
    self.save
  end

end
