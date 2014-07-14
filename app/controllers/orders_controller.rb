class OrdersController < ApplicationController

  def checkout
    @PaymentOptions = PaymentOption.all
    @order = Order.new
  end


  def old_create
    @user = User.find_or_create_by(:email => params[:stripeEmail])

    payment_option_id = params['payment_option']
    raise Exception.new("No payment option was selected") if payment_option_id.nil?
    payment_option = PaymentOption.find(payment_option_id)
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

  def create
    @user = User.find_or_create_by(:email => params[:order][:email])
    save_order_info

    if @error
      redirect_to checkout_path, notice: @message
      destroy_order
    else
      create_stripe_charge(@order.uuid)
      if session[:charged_successful]
        flash.now[:notice] = 'Payment successfully completed'
        redirect_to root_path
      else
        logger.error('Invalid stripe payment')
        destroy_order
        redirect_to checkout_path, notice: 'Card charge not possible. Please check Payment Details and try again.'
      end
    end
  end

  def save_order_info

    @order = Order.new(
        name: params[:order][:name],
        email: params[:order][:email],
        address_one: params[:order][:address_one],
        address_two: params[:order][:address_two],
        city: params[:order][:city],
        state: params[:order][:state],
        zip: params[:order][:zip],
        country: params[:order][:country],
        billing_full_name: params[:order][:billing_full_name],
        billing_email: params[:order][:billing_email],
        billing_address1: params[:order][:billing_address1],
        billing_address2: params[:order][:billing_address2],
        billing_city: params[:order][:billing_city],
        billing_state: params[:order][:billing_state],
        billing_zip: params[:order][:billing_zip],
        billing_country: params[:order][:billing_country],
        user_id: @user.id
    )

    if @order.save!
      params[:order][:payment_option].each_with_index do |payment, index |
        @order_detail = OrderDetail.new(
          payment_option_id: index,
          order_uid: @order.uuid,
          price: payment[:price],
          quantity: payment[:quantity]
        )

        @order_detail.save!

        @order_detail.payment_option.change_quantity(- @order_detail.quantity.to_i)
      end
    end

  rescue Exception => ex
    logger.error("Error when saving order and order detail: #{ex.message}")
    @error   =  true
    @message =  'Order create not possible. Please try again.'
  end

  def save_transaction(order)

      order_total                = 0

      transaction = Transaction.new(
          order_id: order.uuid,
          status: Transaction::STATUS[:paid],
          order_total: 0,
      )
      transaction.save!
  rescue Exception => ex
    logger.error("Error when saving transaction: #{ex.message}")
    @error   =  true
    @message =  'Transaction create not possible. Please try again.'

  end

  def create_stripe_charge(order_id)
    token = params[:stripeToken]

    customer = create_customer(order_id, token)

    transaction = Transaction.find_by_order_id(order_id)

    # Set your secret key: remember to change this to your live secret key in production
    # See your keys here https://dashboard.stripe.com/account
    Stripe.api_key = STRIPE_SECRET_KEY

    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      data_json = Stripe::Charge.create(
          :amount => 1000, # amount in cents, again
          :currency => "usd",
          :card => token,
          :description => "payinguser@example.com",
          :metadata => { 'order_id' => order_id },
      )

      @charge = data_json

      if @charge.present? && valid_stripe_charge?(@charge.id)
        transaction.update_attributes(stripe_charge_id: @charge.id, card_brand: @charge.card.type)
        session[:charged_successful] = true
      end
    rescue Stripe::CardError => ex
      logger.error("Error when charge buyers card: #{ex.message}")
    end

  rescue Stripe::CardError => ex
    logger.error("Error when charge buyers card: #{ex.message}")
  end

  def create_customer(order_id, token)
    Stripe.api_key = STRIPE_SECRET_KEY

    # Create a Customer
    Stripe::Customer.create(
        :card => token,
        :description => "Customer for order id: #{order_id}"
    )
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

  def destroy_order
    Order.find(@order.uuid).destroy if Order.where(uuid: @order.uuid).present?
  end

end
