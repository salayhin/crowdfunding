class OrdersController < ApplicationController

  def checkout
    @PaymentOptions = PaymentOption.all
    @order = Order.new
  end

end
