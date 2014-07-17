class PaymentOption < ActiveRecord::Base
  has_many :order_details
  has_many :orders, through: :order_details

  # (+quantity) add quantity, (-quantity) remove quantity
  def change_quantity(quantity)
    self.limit = self.limit + quantity
    self.save
  end
end
