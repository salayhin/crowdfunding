class Transaction < ActiveRecord::Base
  belongs_to :order

  STATUS = {
      paid: 'paid',
      refunded: 'refunded'
  }
end
