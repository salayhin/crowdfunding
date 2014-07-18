class ChargesController < ApplicationController
  def create
    @user = User.find_or_create_by(:email => params[:stripeEmail])

    payment_option_id = params['payment_option']
    raise Exception.new("No payment option was selected") if payment_option_id.nil?
    payment_option = Product.find(payment_option_id)
    price = payment_option.amount

    @order = Order.prefill!(:name => params[:stripeBillingName], :price => params[:amount], :user_id => @user.id, :payment_option => payment_option)

    customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :card  => params[:stripeToken]
    )

    data_json = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => (price * 100).round,
        :description => "Charge for #{@order.uuid}",
        :currency    => 'usd',
        metadata: { 'order_id' => @order.uuid },
    )

    @charge = data_json

    if @charge.present? && valid_stripe_charge?(@charge.id)
      @order = Order.postfill!(@charge)
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
    end

    def valid_stripe_charge?(charge_id)
      stripe_charge_retrieve = Stripe::Charge.retrieve(charge_id)
      if stripe_charge_retrieve.present? && stripe_charge_retrieve.paid
        return true
      end

    rescue Exception => ex
      logger.error("Charge Id mismatch with Stripe.#{ex.message}")
      return false
    end
end
