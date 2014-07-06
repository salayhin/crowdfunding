class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html { }
    end
  end

  def tileapp

  end

  def price_list
    @PaymentOptions = PaymentOption.all
  end

  def showcase
    @PaymentOptions = PaymentOption.all
  end
end
