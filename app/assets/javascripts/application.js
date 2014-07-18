// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require html5shiv-printshiv
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require modernizr.custom
//= require jquery.ui.all
//= require jquery.details
//= require jquery.textchange
// require finsix_503f3555
// require retina.min
//= require jquery.scrollto.min
//= require smoothscroll
// require jquery.mb.ytplayer
// require jquery.parallax
// require jquery.isotope.min
// require jquery.nav
// require jquery.knob
// require jquery.tweet.min
// require prodo.min
// require pen_hover
//= require preorder
// require_tree .
//= require_self

function isEmpty(obj) {
    for(var prop in obj) {
        if(obj.hasOwnProperty(prop))
            return false;
    }

    return true;
}

/* cart */
$(document).ready(function(){

    var lineItems = { };

    var shoeHideCart = function() {
        if(isEmpty(lineItems)) {
            $('#cart-div').hide();
            $('.cart-is-empty').show();
            $('.complete-the-form').hide();
        } else {
            $('#cart-div').show();
            $('.cart-is-empty').hide();
            $('.complete-the-form').show();
        }
    }

    var calculateTotal = function() {
        var sum = 0;
        for (var key in lineItems) {
            if (lineItems.hasOwnProperty(key)) {
                var cart_item = lineItems[key];
                sum = sum +  parseFloat(cart_item['price']);
            }
        }
        var cart_price = $('#cart-price');
        cart_price.find('.sub-total .product-price').html('$' + sum);
        cart_price.find('.total-price .product-price').html('$' + sum);
    }

    var addToCart = function(pId, price) {
        if(typeof lineItems[pId] == 'undefined' || lineItems[pId] == null) {
            lineItems[pId] = {};
            lineItems[pId]['qt'] = 1;
            lineItems[pId]['price'] = price;
            var qt = 1;

            var cart_item = $('#blank-cart-item li').clone();
            cart_item.css('display', 'block');
            cart_item.attr('id', 'cart-item-' + pId);

            var showcase_item = $('#showcase-item-' + pId);
            //showcase_item.find('.showcase-item-qt').html(1);
            showcase_item.find('.showcase-item-select .qt').html(1);
            var p_name = showcase_item.find('.p_name').html();
            var p_description = showcase_item.find('.p_description').html();

            cart_item.find('.product-name').html(p_name);
            cart_item.find('.product-description').html(p_description);
            cart_item.find('.product-quantity').html('1X');
            cart_item.find('.product-price').html('$' + price);
            //cart_item.find('.payment_option_id').val(pId);
            //cart_item.find('.payment_option_price').val(price);

            cart_item.find('.product_price').val(price).removeAttr('disabled').attr('name', "order['product']['" + pId + "']['price']");
            cart_item.find('.product_quantity').val(qt).removeAttr('disabled').attr('name', "order['product']['" + pId + "']['quantity']");

            $('#cart-items').append(cart_item);
        } else {
            var qt = parseInt(lineItems[pId]['qt'], 10);
            if(qt >= 10) { return false; } //do not add more than 10 products in lineItems;

            var showcase_item = $('#showcase-item-' + pId);
            var cart_item = $('#cart-item-' + pId);
            qt = qt + 1;

            var totalPrice = price * qt;
            lineItems[pId]['qt'] = qt;
            lineItems[pId]['price'] = totalPrice;

            //showcase_item.find('.showcase-item-qt').html(qt);
            showcase_item.find('.showcase-item-select .qt').html(qt);
            cart_item.find('.product-quantity').html(qt + 'X');
            cart_item.find('.product-price').html('$' + totalPrice);
//            cart_item.find('.payment_option_quantity').val(qt);

            cart_item.find('.product_price').val(price).removeAttr('disabled').attr('name', "order['product']['" + pId + "']['price']");
            cart_item.find('.product_quantity').val(qt).removeAttr('disabled').attr('name', "order['product']['" + pId + "']['quantity']");
        }

        calculateTotal();
        shoeHideCart();
    };

    var removeFromCart = function(pId, price) {
        if(typeof lineItems[pId] == 'undefined' || lineItems[pId] == null) { return false; }

        var qt = parseInt(lineItems[pId]['qt'], 10);

        if(qt == 1) {
            delete lineItems[pId];

            var showcase_item = $('#showcase-item-' + pId);
            //showcase_item.find('.showcase-item-qt').empty();
            showcase_item.find('.showcase-item-select .qt').html(0);
            $('#cart-item-' + pId).remove();
        } else if(qt > 1) {
            qt = qt - 1;
            var totalPrice = price * qt;
            lineItems[pId]['qt'] = qt;
            lineItems[pId]['price'] = totalPrice;

            var showcase_item = $('#showcase-item-' + pId);
            var cart_item = $('#cart-item-' + pId);

            //showcase_item.find('.showcase-item-qt').html(qt);
            showcase_item.find('.showcase-item-select .qt').html(qt);

            cart_item.find('.product-quantity').html(qt + 'X');
            cart_item.find('.product-price').html('$' + totalPrice);
        }

        calculateTotal();
        shoeHideCart();
    };

    $('.showcase-item').on('click', '.minus', function(){
        var item = $(this).parent().parent().parent();
        var pId = item.data('pid');
        var price = item.data('price');
        removeFromCart(pId, price);
    });
    $('.showcase-item').on('click', '.plus', function(){
        var item = $(this).parent().parent().parent();
        var pId = item.data('pid');
        var price = item.data('price');
        addToCart(pId, price);
    });
});
/* .cart */

$(document).ready(function(){
    $(".carousel").carousel();
    $(".carousel-indicators").on('click', 'li', function(){
        return false;
    });
    $('#iphoneCarousel').carousel();
    $("#iphoneCarousel").on('click', 'li', function(){
        return false;
    });
});
$(document).ready(function(){
   $('.faq-question').on('click', function(){
       $(this).next().toggle('slow');
   });

   $('.site-menu a').on('click', function(){
       var target = $(this).data('target');
       var go_to = $('.'+target).position().top;
       go_to += 'px';
       $("html, body").animate({ scrollTop: go_to });
       return false;
   });
   $('#same-address').on('change', function(){
       var is_same = $('#same-address').is(":checked");
       if(is_same) {
           $('.billing-address-form').hide();
       } else {
           $('.billing-address-form').show();
       }
   });
});


$(document).ready(function(){

    // This identifies your website in the createToken call below
    Stripe.setPublishableKey('pk_test_q4ZNLiQWrYZTs3pxKSMxuJ6f');


    // Payment
    $(document).on('submit', '#new_order', function(){
        var $form = $(this);
        $form.find('.place-order').prop('disabled', true);

        var expire_date = $('.card-date').val().split('/');

        //if(address_validation()){
        Stripe.card.createToken({
            number: $('.credit-card-number').val(),
            cvc: $('.card-cvc').val(),
            exp_month: parseInt(expire_date[0]),
            exp_year: parseInt(expire_date[1])
        }, stripeResponseHandler);
        //}
        $form.find('.payment_submit').prop('disabled', false);
        return false;
    });


    // ...

    var stripeResponseHandler = function(status, response) {
        var $form = $('#new_order');
        if (response.error){
            $form.find('.payment-errors').html('<div class="error_explanation"><h2>' + response.error.message + '</h2></div>');
            switch (response.error.code){
                case 'incorrect_number':
                    addErrorMessage($('#credit_card_number'), 'Incorrect');
                    break;
                case 'invalid_number':
                    addErrorMessage($('#credit_card_number'), 'Invalid');
                    break;
                case 'invalid_expiry_month':
                    addErrorMessage($('#month_wrapper .jqTransformSelectWrapper'), 'Invalid');
                    break;
                case 'invalid_expiry_year':
                    addErrorMessage($('#year_wrapper .jqTransformSelectWrapper'), 'Invalid');
                    break;
                case 'invalid_cvc':
                    addErrorMessage($('#cvv'), 'Invalid');
                    break;
                case 'expired_card':
                    addErrorMessage($('#credit_card_number'), 'Expired');
                    break;
                case 'incorrect_cvc':
                    addErrorMessage($('#cvv'), 'Incorrect');
                    break;
                case 'card_declined':
                    addErrorMessage($('#credit_card_number'), 'Declined');
            }
            $form.find('.payment_submit').prop('disabled', false);
        }
        else{
            var token = response.id;
            $form.append($("<input type='hidden' name='stripeToken' />").val(token));
            $form.get(0).submit();
        }
    };

    function addErrorMessage(element, message){
        if(!element.parent().hasClass('field_with_errors')){
            element.wrap('<div class="field_with_errors"></div>');
            element.after('<label class="message">' + message + '</label>');
        }
    }

    function address_validation() {
        var $order_shipping_first_name  =   $('#order_shipping_first_name');
        var $order_shipping_last_name   =   $('#order_shipping_last_name');
        var $order_shipping_email       =   $('#order_shipping_email');
        var $order_shipping_address1    =   $('#order_shipping_address1');
        var $order_shipping_city        =   $('#order_shipping_city');
        var $order_shipping_zip_code    =   $('#order_shipping_zip_code');

        var $other_billing_address      =   $('#other_billing_address');
        var $order_first_name           =   $('#order_first_name');
        var $order_last_name            =   $('#order_last_name');
        var $order_email                =   $('#order_email');
        var $order_address1             =   $('#order_address1');
        var $order_city                 =   $('#order_city');
        var $order_zip_code             =   $('#order_zip_code');

        var $card_number = $('.card-number');
        var $card_cvc = $('.card-cvc');
        var is_pass                     =   true;

        removeAllErrorMessage();
        if($order_shipping_first_name.val() == ''){
            addErrorMessage($order_shipping_first_name, 'Required');
            is_pass = false;
        }

        if($order_shipping_last_name.val() == ''){
            addErrorMessage($order_shipping_last_name, 'Required');
            is_pass = false;
        }

        if($order_shipping_email.val() == ''){
            addErrorMessage($order_shipping_email, 'Required');
            is_pass = false;
        }
        else if(!is_valid_email($order_shipping_email.val())){
            //email validation
            addErrorMessage($order_shipping_email, 'Invalid Email');
            is_pass = false;
        }

        if($order_shipping_address1.val() == ''){
            addErrorMessage($order_shipping_address1, 'Required');
            is_pass = false;
        }

        if($order_shipping_city.val() == ''){
            addErrorMessage($order_shipping_city, 'Required');
            is_pass = false;
        }

        if($order_shipping_zip_code.val() == ''){
            addErrorMessage($order_shipping_zip_code, 'Required');
            is_pass = false;
        }

        if($other_billing_address.is(':checked')){
            if($order_first_name.val() == ''){
                addErrorMessage($order_first_name, 'Required');
                is_pass = false;
            }

            if($order_last_name.val() == ''){
                addErrorMessage($order_last_name, 'Required');
                is_pass = false;
            }

            if($order_email.val() == ''){
                addErrorMessage($order_email, 'Required');
                is_pass = false;
            }
            else if(!is_valid_email($order_email.val())){
                // email validation
                addErrorMessage($order_email, 'Required');
                is_pass = false;
            }

            if($order_address1.val() == ''){
                addErrorMessage($order_address1, 'Required');
                is_pass = false;
            }

            if($order_city.val() == ''){
                addErrorMessage($order_city, 'Required');
                is_pass = false;
            }

            if($order_zip_code.val() == ''){
                addErrorMessage($order_zip_code, 'Required');
                is_pass = false;
            }
        }

        if($card_number.val() == ''){
            addErrorMessage($card_number, 'Required');
            is_pass = false;
        }
        if($card_cvc.val() == ''){
            addErrorMessage($card_cvc, 'Required');
            is_pass = false;
        }

        if(!is_pass){
            errorMessageOnTop($('.content'), 'You are so close! Please fill in the missing information outlined in red');
            $('html, body').animate({scrollTop: top}, 'slow');
        }
        return is_pass;
    }

});
