/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


$(document).ready(function() {
    $(".pen_1_menu_colors .tooltipstered").mouseover(function() {
        var hover_color_class = $(this).data('class');
        var active_color_class = $('.pen_1').data('color');
        $('.pen_1').removeClass(active_color_class);
        $('.pen_1').data('color', hover_color_class);
        $('.pen_1').addClass(hover_color_class);
        $(this).find('span').fadeIn();
    }).mouseout(function() {
        $(this).find('span').fadeOut();
    });

    $(".pen_2_menu_colors .tooltipstered").mouseover(function() {
        var hover_color_class = $(this).data('class');
        var active_color_class = $('.pen_2').data('color');
        $('.pen_2').removeClass(active_color_class);
        $('.pen_2').data('color', hover_color_class);
        $('.pen_2').addClass(hover_color_class);
        $(this).find('span').fadeIn();
    }).mouseout(function() {
        $(this).find('span').fadeOut();
    });

});