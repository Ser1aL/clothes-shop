$(function(){
//  $.history.init(function(url){
//    var url_parser = $.url(document.location);
//    //Forcing redirect if location hash exists and page is not an Advanced Search
//    if (url_parser.segment(1) != '' && url_parser.segment(1) != 'advanced_search'){
//      if (url_parser.fsegment(1) != ''){
//          document.location = 'http://' + document.location.host + '/#' + url_parser.fsegment().join('/');
//      }
//      return false;
//    }
//    if(url_parser.segment(1) != 'advanced_search'){
//        load_categorized_or_single_page(url_parser);
//    }
//    else{
//        load_search_page(parse_search_parameters(url_parser));
//    }
//
//  },
//  { unescape: "/" });

  $('.cart_quantity').blur(function(){
    $(this).parent().submit();
  });

  $('.submit_quantity').click(function(){
    return false;
  });

  $('#hide a').click(function(){
    $('#delivery_options').toggle();
    return false;
  });


  $('#register_link, #registration_popup_close').click(function(){
    $('#registration_popup').toggle();
    return false;
  });

  $('#registration_submit').click(function(){
    $('#registration_form').submit();
    return false;
  });

  $('#back_link').click(function(){
    history.back(1);
    return false;
  });

  $('#payment_button').click(function(){
    $('#prepayment_form').submit();
    return false;
  });

  $('#submit_order').click(function(){
    $('#submit_order_form').submit();
    return false;
  });

  $('.delete_icon').click(function(){
      $(this).parent().submit();
      return false;
  });

  $('.refresh_icon').click(function(){
      return false;
  });

  $('.login_button').click(function(){
    $('#login_wrapper').toggle();
    return false;
  });

  $('#login_submit').click(function(){
    $('#login_form').submit();
    return false;
  });

  $('#registration_submit_detailed').click(function(){
    $('#user_new').submit();
    return false;
  });

  $('#login_submit_detailed').click(function() {
      $('#login_form_detailed form').submit();
      return false;
  });

  $("#edit_user").click(function(){
    $("form.edit_user").submit();
    return false;
  });

  $("#edit_user_password").click(function(){
      $(".user_edit_password_form").closest('form').submit();
      return false;
  });

  $("#hide_user_edit_form").click(function(){
    if($(".user_edit_form.hidden").is(':visible')){
      $(".user_edit_form.hidden").hide();
    }
    else{
      $(".toggle").toggle();
    }
    return false;
  });

  $(".show_user_order").click(function(){
    var id = 0;
    id = $(this).attr("id");
    $("#order_table_wrapper_"+id).toggle();
    return false;
  });

  $("#show_user_edit_form").click(function(){
    $(".toggle").hide();
    $(".user_edit_form").show();
    return false;
  });

  $('.mcl_show_more').click(function(event){
      event.preventDefault();
      $(this).closest('ul').find('.hidden_link').removeClass('hidden_link');
      $(this).remove();
  });

  activate_selection_popups();
  if($('#flash_message').length > 0) {
      if ($('#flash_message').hasClass('noclose')) {
          $('#flash_message').modal({close: false});
      }
      else {
          $('#flash_message').modal();
      }
  }

  $('.support_call').click(function(event){
      event.preventDefault();
      $('#order_call').modal();
  });

  $('.callback-button a').click(function(event){
      event.preventDefault();
      $(this).closest('form').submit();

      $('#simplemodal-overlay').hide();
      $('#simplemodal-container').hide();
  });

  $('.submit_order_call .button').click(function(event){
      event.preventDefault();
      if($('.phone_number_wrapper form .input_style input').val().length > 0) {
          $('.phone_number_wrapper form').submit();
      }
  });


  $(".ajaxified_translation").click(function(){
    $(this).val("Сохраняем");
  });

  $(".trigger_tab").click(function(event){
      event.preventDefault();
      var tab = $(this).data('to');
      $(".tabable").addClass('invisible');
      $("." + tab).removeClass('invisible');
      $('.trigger_tab').addClass('pd_anactive_button');
      $(this).removeClass('pd_anactive_button').addClass('pd_active_button');
  });

//  prepare_paginated_links();
  activate_price_filter();
//  prepare_ajaxified_links();
  activate_sizes_dropdown();
  activate_previews();
  activate_size_grid();
  activate_zoom();
  activate_video_and_description_links();
  activate_comment_controls();


    $(".footer_button_send.footer .button").click(function(event){
      event.preventDefault();
      var form = $(this).closest("form");
      var email_field = form.find("#review_email");
      var name_field = form.find("#review_name");
      var body_field = form.find("#review_body");

      if(email_field.val().length == 0 || !is_valid_email_address(email_field.val())){
          alert(email_field.data().errorMessage);
      }
      else if(body_field.val().length == 0){
          alert(body_field.data().errorMessage);
      }
      else if(name_field.val().length == 0){
          alert(name_field.data().errorMessage);
      }
      else{
          $(this).closest("form").submit();
      }
    });


});

function activate_navigation_button(button_name){
  $('.navigation_buttons #'+button_name+' .button_left_idle').removeClass("button_left_idle").addClass("button_left");
  $('.navigation_buttons #'+button_name+' .button_mid_idle').removeClass("button_mid_idle").addClass("button_mid");
  $('.navigation_buttons #'+button_name+' .button_right_idle').removeClass("button_right_idle").addClass("button_right");
}

function activate_sizes_dropdown(){
    $(".add_to_cart_link").click(function(event){
        event.preventDefault();
        $("#add_to_cart_form").submit();
    });
}

function activate_size_grid(){
    $(".size_grid a").popupWindow({
        height:730,
        width:1200,
        top:50,
        left:50
    });
}

function activate_price_filter(){
    var max_price = $("#max_price").html();
    var selected_min_price = $('.price_filter').data('current_min');
    var selected_max_price = $('.price_filter').data('current_max');

    var currency = $("#currency").html();
    $('#price_filter').val(selected_min_price + '-' + selected_max_price);
    $("#price_slider").slider({
        range:true,
        min: 0,
        max: max_price,
        values:[selected_min_price, selected_max_price],
        step: 5,
        slide: function( event, ui ) {
            $("#price_range_label").html(ui.values[ 0 ] + ' ' + currency + ' - ' + ui.values[ 1 ] + ' ' + currency);
        },
        stop: function(event, ui){
            var price_range = ui.values[0] + '-' + ui.values[1];
            var uri = $.url(location.href);
            var redirect_to = '/' + uri.segment().join('/') + '?';
            if(uri.param().size || uri.param().color){
                if(uri.param().size && uri.param().color){
                    redirect_to = redirect_to + 'color=' + uri.param().color + '&size=' + uri.param().size + '&price_range=' + price_range;
                }
                else if(uri.param().color){
                    redirect_to = redirect_to + 'color=' + uri.param().color + '&price_range=' + price_range;
                }
                else if(uri.param().size){
                    redirect_to = redirect_to + 'size=' + uri.param().size + '&price_range=' + price_range;
                }

            }
            else{
                redirect_to = redirect_to + 'price_range=' + price_range;
            }
            location.href = redirect_to;
        }
    });
}

function activate_previews(){
    $(".previews").click(function(event){
        $(".inner_zoom").attr("href", $(this).attr("href"));
        $(".inner_zoom").attr("rel", $(this).attr("rel"));
        $(".inner_zoom img").remove();
        $(".inner_zoom").data("jqzoom", false);
        $(".inner_zoom").append("<img src='" + $(this).attr("href") + "' title=''>");
        $(".inner_zoom").unbind();
        $(".zoomPad").remove()
        event.preventDefault();
        activate_zoom();
    });
}

function activate_zoom(){
    var inner_zoom_options = {
        zoomType: 'innerzoom',
        howEffect: 'fadein',
        hideEffect: 'fadeout'
    };

    $('.inner_zoom').click(function(event){
        event.preventDefault();
        if( typeof($(this).attr("rel")) != 'undefined' ) $(this).jqzoom(inner_zoom_options);
    });
}

function is_valid_email_address(emailAddress) {
    var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
    return pattern.test(emailAddress);
}

function activate_video_and_description_links(){
    $(".trigger_video a").click(function(event){
        event.preventDefault();
        $(".video").slideToggle();
    });

    $(".trigger_description a").click(function(event){
        event.preventDefault();
        $(".single_product_description").slideToggle();
    });
}

function activate_comment_controls(){
    $('#comments_toggle').click(function(){
        $('#comment_wrapper').toggle();
        return false;
    });

    $('.submit_comment').click(function(){
        if ( $('#comment_text_area textarea').val() != '' ){
            $('#comment_loader').show();
            $('#new_comment_form').submit();
        }
        return false;
    });

    $('.delete_comment').click(function(){
        $('#comment_loader').show();
    });
}


//function prepare_paginated_links(page_type){
//    // skip articles pager and categories page
//    if($(".articles").length > 0 || $('.category-page').length > 0) return;
//    if(page_type != 'cat' && page_type != 'search') {
//        var page = '';
//        $.each($(".pager a"), function(index, url) {
//            page = $.url(url.href).data.param.query.page;
//            if(page == undefined) page = '1';
//            var current_hash = location.hash;
//            if(current_hash.match(/p=(\d+)/)){
//                $(url).attr('href', current_hash.replace(/p=(\d+)/, 'p='+page));
//            }
//            else if(current_hash == ''){
//                $(url).attr('href', '#p=' + page);
//            }
//            else{
//                $(url).attr('href', current_hash + '&p=' + page);
//            }
//        });
//    }
//    if(page_type == 'search') {
//        $.each($(".pager a"), function(index, pager_url) {
//            var url = $.url(this.href);
//            var page = url.param('page') == undefined ? 1 : parseInt(url.param('page'));
//            var search_query = url.param('search_query') == undefined ? '' : url.param('search_query');
//            $(pager_url).attr('href', '#' + page_type + '/' + search_query + '/' + page);
//        });
//    }
//    $(".pager a").click(function() {
//        var url = $.url(this.href);
//        if (page_type == 'cat'){
//            var brand = url.param('brand') == undefined ? '' : url.param('brand');
//            var category = url.param('category') == undefined ? '' : url.param('category');
//            var sub_category = url.param('sub_category') == undefined ? '' : url.param('sub_category');
//            var gender = url.param('gender') == undefined ? '' : url.param('gender');
//            var page = url.param('page') == undefined ? '' : url.param('page');
//            var params = brand + '/' + category + '/' + sub_category + '/' + gender + '/' + page;
//            $.history.load( page_type + '/' + params );
//        }
//        // else it is an advanced search
//        else return true;
//        return false;
//    });
//    prepare_ajaxified_links();
//}

function prepare_ajaxified_links(){
    $('.ajaxified_disabled_link').click(function(){ return false; })
}

function incrementCommentCount(){
    var count_now = $('#comments_toggle').html().match(/(\d+)/)[0];
    var new_count = parseInt(count_now) + 1;
    $('#comments_toggle').html($('#comments_toggle').html().replace(/(\d+)/, new_count));
}

function decrementCommentCount(){
    var count_now = $('#comments_toggle').html().match(/(\d+)/)[0];
    var new_count = parseInt(count_now) - 1;
    $('#comments_toggle').html($('#comments_toggle').html().replace(/(\d+)/, new_count));
}

function set_default_navigation(){
    $.each(['category', 'gender', 'sub_category'], function(index, value){
        $('.navigation_buttons #'+value+' .button_left').removeClass("button_left").addClass("button_left_idle");
        $('.navigation_buttons #'+value+' .button_mid').removeClass("button_mid").addClass("button_mid_idle");
        $('.navigation_buttons #'+value+' .button_right').removeClass("button_right").addClass("button_right_idle");
    });

    $('.navigation_buttons #brand .button_mid').html('Бренды');
    $('.navigation_buttons #category .button_mid_idle').html('Категории');
    $('.navigation_buttons #sub_category .button_mid_idle').html('Подкатегории');
    $('.navigation_buttons #gender .button_mid_idle').html('Тип');

}

function activate_selection_popups(){
    var options = ['brand', 'category', 'sub_category', 'gender'];
    $.each(options, function(index, value){
        $('#navigation .navigation_buttons #'+value).hover(
            function(){
                $('.pop_up_style_choice_'+value).show();
                $.each(options, function(inner_index, inner_value){
                    if(index != inner_index){
                        $('.pop_up_style_choice_'+inner_value).hide();
                    }
                });
            },
            function(){
                $('.pop_up_style_choice_'+value).hide();
            }
        );
        $('.pop_up_style_choice_'+value).hover(
            function(){
                $('.pop_up_style_choice_'+value).show();
            },
            function(){
                $('.pop_up_style_choice_'+value).hide();
            }
        );
    });
}


