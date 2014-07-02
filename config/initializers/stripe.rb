Rails.configuration.stripe = {
    # :publishable_key => ENV['PUBLISHABLE_KEY'],
    # :secret_key      => ENV['SECRET_KEY'],
    # :publishable_key => 'pk_test_q4ZNLiQWrYZTs3pxKSMxuJ6f',
    # :secret_key      => 'sk_test_bDV8XKnlEG6M43QfLnYvBODO',
    :publishable_key => 'pk_test_0WDNPL8AxxfCAk1XmcywFN2U',
    :secret_key      => 'sk_test_p9N3IpnM6nqhrGITPvJCGaPf'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]