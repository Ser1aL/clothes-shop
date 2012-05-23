function prepare_paginated_links(page_type){
  $(".pager a").click(function() {
    $('#loader').show();
    var url = $.url(this.href);
    if (page_type == 'cat'){
      brand = url.param('brand') == undefined ? '' : url.param('brand');
      category = url.param('category') == undefined ? '' : url.param('category');
      sub_category = url.param('sub_category') == undefined ? '' : url.param('sub_category');
      gender = url.param('gender') == undefined ? '' : url.param('gender');
      page = url.param('page') == undefined ? '' : url.param('page');
      params = brand + '/' + category + '/' + sub_category + '/' + gender + '/' + page;
      $.history.load( page_type + '/' + params );
    }
    else if (page_type == 'search'){
      page = url.param('page') == undefined ? '' : url.param('page');
      search_query = url.param('search_query') == undefined ? '' : url.param('search_query');
      $.history.load( page_type + '/' + search_query + '/' + page );
    }
    else{
      page = url.param('page') == undefined ? '' : url.param('page');
      $.history.load( page_type + '/' + page );
    }
    return false;
  });
  prepare_ajaxified_links();
}

function prepare_ajaxified_links(){
  $(".product_details_link a, .single_product_ajaxified_link").click(function() {
    $('#loader').show();
    var url = $.url(this.href);
    var style_id = url.param('style');
    var item_model_id = url.segment(2);
    $.history.load( 'single/' + item_model_id + '/' + style_id );
    return false;
  });
  $('.ajaxified_disabled_link').click(function(){ return false; })
}

function incrementCommentCount(){
  count_now = $('#comments_toggle').html().match(/(\d+)/)[0];
  new_count = parseInt(count_now) + 1;
  $('#comments_toggle').html($('#comments_toggle').html().replace(/(\d+)/, new_count));
}

function decrementCommentCount(){
  count_now = $('#comments_toggle').html().match(/(\d+)/)[0];
  new_count = parseInt(count_now) - 1;
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

function reload_selection_links(brand_id, category_id, style_id, mechanism_id){
  $('.brand_changable').each(function(){
    href = $(this).attr('href');
    matches = href.match(/(#cat)\/(.*)\/(.*)\/(.*)\/(.*)/);
    brand = brand_id == '' ? matches[2] : brand_id;
    category = category_id == '' ? matches[3] : category_id;
    style = style_id == '' ? matches[4] : style_id;
    mechanism = mechanism_id == '' ? matches[5] : mechanism_id;
    $(this).attr('href', '/' + matches[1] + '/' + brand + '/' + category + '/' + style + '/' + mechanism);
  })
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

$(function(){
  $.history.init(function(url){
    var url_parser = $.url(document.location);
    if (url_parser.segment(1) != ''){
      //Forcing redirect if location hash exists
      if (url_parser.fsegment(1) == ''){
        return false;
      }
      else{
        document.location = 'http://' + document.location.host + '/#' + url_parser.fsegment().join('/');
      }
    }
    var script_name = '/.js';
    var query = '';
    page_type = url_parser.fsegment(1);
    //alert(page_type);
    if (page_type == 'top'){
      query = '?page=' + url_parser.fsegment(2);
    }
    else if(page_type == 'cat'){
      script_name = '/preload.js';
      query = '?';
      if (url_parser.fsegment(2) != '' && url_parser.fsegment(2) != undefined){
        query += 'brand=' + url_parser.fsegment(2) + '&';
      }
      if (url_parser.fsegment(3) != '' && url_parser.fsegment(3) != undefined){
        query += 'category=' + url_parser.fsegment(3) + '&';
      }
      if (url_parser.fsegment(4) != '' && url_parser.fsegment(4) != undefined){
        query += 'sub_category=' + url_parser.fsegment(4) + '&';
      }
      if (url_parser.fsegment(5) != '' && url_parser.fsegment(5) != undefined){
        query += 'gender=' + url_parser.fsegment(5) + '&';
      }
      if (url_parser.fsegment(6) != '' && url_parser.fsegment(6) != undefined){
        query += 'page=' + url_parser.fsegment(6) + '&';
      }
    }
    else if(page_type == 'single'){
      script_name = '/item_models/';
      query = url_parser.fsegment(2) + '?style_id=' + url_parser.fsegment(3);

    }
    else if(page_type == 'search'){
      script_name = '/search.js';
      query = '?';
      if (url_parser.fsegment(2) != '' && url_parser.fsegment(2) != undefined){
        query += 'search_query=' + url_parser.fsegment(2) + '&';
      }
      if (url_parser.fsegment(3) != '' && url_parser.fsegment(3) != undefined){
        query += 'page=' + url_parser.fsegment(3) + '&';
      }
    }

    $('#loader').show();
    $.getScript(script_name + query);
  }, { unescape: "/" });

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

  $('.submit_search').click(function(){
    if ($('#search_query').val() == '') return false;
    $('#search_form').submit();
    return false;
  });

  $('#search_form').submit(function(){
    $('#loader').show();
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

  $('#login_submit_detailed, #registration_submit_detailed').click(function(){
    $('#user_new').submit();
    return false;
  });

  $("#edit_user").click(function(){
    $("form.edit_user").submit();
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

  activate_selection_popups();
  if($('#flash_message').length > 0) $('#flash_message').modal();
  $(".jstree")
    .bind("loaded.jstree", function () {
      $(".jstree li a").click(function(){
          window.location = $(this).attr("href");
      });
    })
    .jstree({
        "themes" : {
           "theme" : "default",
            "icons" : false,
            "url" : '/stylesheets/themes/default/style.css'
        }
    });
    init_slider();

  $(".ajaxified_translation").click(function(){
    $(this).val("Сохраняем");
  });
});

function activate_lightbox(){
  $('#clock_images a').lightBox({fixedNavigation:true});
}

function activate_navigation_button(button_name){
  $('.navigation_buttons #'+button_name+' .button_left_idle').removeClass("button_left_idle").addClass("button_left");
  $('.navigation_buttons #'+button_name+' .button_mid_idle').removeClass("button_mid_idle").addClass("button_mid");
  $('.navigation_buttons #'+button_name+' .button_right_idle').removeClass("button_right_idle").addClass("button_right");
}

function activate_sizes_dropdown(){
    $("#stock_select select").change(function(){
        var stock_id = $(this).find("option:selected").val();
        var link_to_cart = $(".add_to_cart_link a").last();
        var current_url = $.url(link_to_cart.attr("href")); //, link_to_cart.attr("href") + "&stock_id=" + stock_id);
        var result_url = current_url.attr().path + '?' + 'style=' + current_url.data.param.query.style + '&stock_id=' + stock_id;
        link_to_cart.attr('href', result_url);
    });
}

function activate_video_link(){
    $("#video_link").click(function(){
        $("#flv_player_wrapper").slideToggle();
        return false;
    });
}

function init_slider(){
    $('#slides').slides({
        play: 4000,
        pause: 2500
    });
}

function activate_size_grid(){
    $(".size_grid").popupWindow({
        height:730,
        width:1200,
        top:50,
        left:50
    });
}