class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html { }
    end
  end

  def price_list
    @PaymentOptions = PaymentOption.all
  end
end
