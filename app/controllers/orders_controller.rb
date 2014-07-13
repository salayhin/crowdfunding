class OrdersController < ApplicationController

  def checkout
    @PaymentOptions = PaymentOption.all
    @order = Order.new
  end

  def create
    params
  end

end
