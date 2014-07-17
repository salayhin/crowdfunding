class Transaction < ActiveRecord::Base
  belongs_to :order

  STATUS = {
      paid: 'paid',
      refunded: 'refunded'
  }

  STRIPE_PERCENT = 0.029
  STRIPE_AMOUNT = 0.30

  def get_stripe_charge
    self.order_total * STRIPE_PERCENT + STRIPE_AMOUNT
  end
end
