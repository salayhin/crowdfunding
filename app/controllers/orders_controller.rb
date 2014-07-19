class OrdersController < ApplicationController

  def checkout
    @products = Product.all
    @order = Order.new
  end

  def create
    @user = User.find_or_create_by(:email => params[:order][:email])

    if params[:order]["'product'"].nil?
      @error   =  true
      @message =  'Please add product first!.'
      redirect_to checkout_path, notice: @message
      return
    end

    save_order_info

    if @error
      redirect_to checkout_path, notice: @message
      destroy_order(@order)
    else
      create_stripe_charge(@order.uuid)
      if session[:charged_successful]
        flash.now[:notice] = 'Payment successfully completed'
        redirect_to root_path
      else
        logger.error('Invalid stripe payment')
        destroy_order(@order)
        redirect_to checkout_path, notice: 'Card charge not possible. Please check Payment Details and try again.'
      end
    end
  end

  def save_order_info

      @order = Order.new
      @order.first_name = params[:order][:first_name]
      @order.last_name = params[:order][:last_name]
      @order.name = params[:stripeShippingName].present? ? params[:stripeShippingName] : params[:stripeBillingName]
      @order.email = params[:stripeEmail]
      @order.address_one = params[:stripeShippingAddressLine1].present? ? params[:stripeShippingAddressLine1] : params[:stripeBillingAddressLine1]
      @order.address_two = params[:stripeShippingAddressLine2].present? ? params[:stripeShippingAddressLine2] : params[:stripeBillingAddressLine2]
      @order.city = params[:stripeShippingCity].present? ? params[:stripeShippingCity] : params[:stripeBillingCity]
      @order.zip = params[:stripeShippingZip].present? ? params[:stripeShippingZip] : params[:stripeBillingZip]
      @order.country = params[:stripeShippingCountry].present? ? params[:stripeShippingCountry] : params[:stripeBillingCountry]
      @order.billing_full_name = params[:stripeBillingName]
      @order.billing_address1 = params[:stripeBillingAddressLine1]
      @order.billing_address2 = params[:stripeBillingAddressLine2]
      @order.billing_city = params[:stripeBillingCity]
      @order.billing_zip = params[:stripeBillingZip]
      @order.billing_country = params[:stripeBillingCountry]
      @order.user_id = @user.id

    total = 0.0

    if @order.save!
      params[:order]["'product'"].each do |payment|

        @order_detail = OrderDetail.new(
          product_id: payment[0][1..-2].to_i,
          order_id: @order.uuid,
          price: payment[1]["'price'"].to_f,
          quantity: payment[1]["'quantity'"].to_f
        )

        total = total + (payment[1]["'price'"].to_f * payment[1]["'quantity'"].to_f)
        @order_detail.save!

        @order_detail.product.change_quantity(- @order_detail.quantity.to_i)
      end
    end

    save_transaction(@order, total)

  rescue Exception => ex
    logger.error("Error when saving order and order detail: #{ex.message}")
    @error   =  true
    @message =  'Order create not possible. Please try again.'
  end


  def save_transaction(order, order_total)

      transaction = Transaction.new(
          order_id: order.uuid,
          status: Transaction::STATUS[:paid],
          order_total: order_total
      )
      transaction.save!
  rescue Exception => ex
    logger.error("Error when saving transaction: #{ex.message}")
    @error   =  true
    @message =  'Transaction create not possible. Please try again.'

  end

  def create_stripe_charge(order_id)
    transaction = Transaction.find_by_order_id(order_id)

    begin
      customer = Stripe::Customer.create(
          :email => params[:stripeEmail],
          :card  => params[:stripeToken]
      )

      data_json = Stripe::Charge.create(
          :customer    => customer.id,
          :amount      => (transaction.order_total * 100).round,
          :description => "Charge for #{@order.uuid}",
          :currency    => 'usd',
          metadata: { 'order_id' => order_id },
      )

      @charge = data_json

      if @charge.present? && valid_stripe_charge?(@charge.id)
        transaction.update_attributes(stripe_charge_id: @charge.id, stripe_customer_id: @charge.customer,
                                      card_last_4_digit: @charge.card.last4,  card_brand: @charge.card.type,
                                      card_exp_month: @charge.card.exp_month, card_exp_year: @charge.card.exp_year,
                                      is_paid: @charge.paid, is_refunded: @charge.refunded,
                                      stripe_charge: transaction.get_stripe_charge)
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

  def destroy_order(order)
    Order.find_by_uuid(order.uuid).destroy if Order.where(id: order.uuid).present?
  end
end
