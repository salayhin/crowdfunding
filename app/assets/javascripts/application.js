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
                sum = sum + cart_item['price']
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
    $(".carousel").carousel()
});