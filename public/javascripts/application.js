$.ajaxSetup({
    cache: true
});

function prepare_paginated_links(page_type){
  // Replace url for advanced search pagination
  if(page_type != 'cat' && page_type != 'search') {
      var page = ''
      $.each($(".pager a"), function(index, url) {
          page = $.url(url.href).data.param.query.page;
          if(page == undefined) page = '1';
          var current_hash = location.hash;
          if(current_hash.match(/p=(\d+)/)){
              $(url).attr('href', current_hash.replace(/p=(\d+)/, 'p='+page));
          }
          else if(current_hash == ''){
              $(url).attr('href', '#p=' + page);
          }
          else{
              $(url).attr('href', current_hash + '&p=' + page);
          }
      });
  }
  $(".pager a").click(function() {
    var url = $.url(this.href);
    if (page_type == 'cat'){
      var brand = url.param('brand') == undefined ? '' : url.param('brand');
      var category = url.param('category') == undefined ? '' : url.param('category');
      var sub_category = url.param('sub_category') == undefined ? '' : url.param('sub_category');
      var gender = url.param('gender') == undefined ? '' : url.param('gender');
      var page = url.param('page') == undefined ? '' : url.param('page');
      var params = brand + '/' + category + '/' + sub_category + '/' + gender + '/' + page;
      $.history.load( page_type + '/' + params );
    }
    else if (page_type == 'search'){
      var page = url.param('page') == undefined ? '' : url.param('page');
      var search_query = url.param('search_query') == undefined ? '' : url.param('search_query');
      $.history.load( page_type + '/' + search_query + '/' + page );
    }
    // else it is an advanced search
    else return true;
    return false;
  });
  prepare_ajaxified_links();
}

function prepare_ajaxified_links(){
  $(".product_details_link a, .single_product_ajaxified_link").click(function() {
    var url = $.url(this.href);
    var style_id = url.param('style');
    var item_model_id = url.segment(2);
    if(document.location.pathname == "" || document.location.pathname == "/"){
        $('#loader').show();
        $.history.load( 'single/' + item_model_id + '/' + style_id );
    }
    else{
        document.location = document.location.protocol + '//' + document.location.host + "/#" + 'single/' + item_model_id + '/' + style_id;
    }
    return false;
  });
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

function load_categorized_or_single_page(url_parser){
    var script_name = '/';
    var query = '';
    var page_type = url_parser.fsegment(1);
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
}

function parse_search_parameters(url_parser){
    var fragment = url_parser.data.param.fragment;
    return {
        category_id : fragment.cat,
        sub_category_id : fragment.sub,
        gender_id : fragment.g,
        price_range : fragment.price_range,
        brand_id : fragment.b,
        page : fragment.p,
        color : fragment.c,
        size : fragment.s
    };
}

function load_search_page(params){
    // Run Ajax Calls to update navigation menu and main part only if params are set

    if(location.hash != ''){
        var result_element = undefined;
        var result_container = undefined;

        $(".item_models").html("<div class='loader'></div>");
        $.ajax({
            url : "/search/load_items",
            data : params
        }).success(function(resp){
            $(".item_models").html(resp);
            prepare_paginated_links();
            jQuery('html, body').animate( { scrollTop: 0 }, 'slow' );
            if(typeof(params.brand_id) != 'undefined' && params.brand_id != ''){
                var brand_element = $("#brand_id_"+params.brand_id+" a .brand_name");
                if(brand_element.length > 0){
                    var selected_brand_name = brand_element.html().trim();
                    $(".navigation_buttons #brand .button_mid").html(selected_brand_name);
                }
            }
        });
        var initialized_params_count = 0;
        for(var i in params){ if(typeof(params[i]) != 'undefined') initialized_params_count += 1 }
        update_filter_removal_panel(params);
        if(initialized_params_count > 0) $(".selected_filters .hint").show(); else $(".selected_filters .hint").hide();
        var sections = ["categories", "genders", "sub_categories", "brands"];
        if(initialized_params_count >= 2){
            sections.push("sizes");
            sections.push("colors");
            $(".price_filter_container").slideDown();
        }
        else{
            $(".price_filter_container").slideUp();
        }
        $.each(sections, function(k, v){
            $("."+v+" .content").html("<div class='loader'></div>");
            $.ajax({
                url : "/search/preload_" + v,
                data : params
            }).success(function(resp){
                result_container = $("."+v);
                result_element = $("."+v+" .content");
                if(resp == null || resp == ''){
                    result_container.slideUp();
                }
                else{
                    result_element.html("");
                    $.each(resp, function(k, respv){
                        var parameters = [];
                        var current_type = '';
                        var filter_element = '';
                        if( typeof(respv.category_id) != "undefined" && respv.category_id != ''){
                            parameters.push("cat=" + respv.category_id);
                            filter_element = $(".category_id_filter span.content");
                            if( parseInt(filter_element.html()) == parseInt(respv.category_id) && v == 'categories' ){
                                filter_element.html(respv.type_name);
                            }

                        }
                        if( typeof(respv.gender_id) != "undefined" && respv.gender_id != ''){
                            parameters.push("g=" + respv.gender_id);
                            filter_element = $(".gender_id_filter span.content");
                            if( parseInt(filter_element.html()) == parseInt(respv.gender_id) && v == 'genders' ){
                                filter_element.html(respv.type_name);
                            }
                        }
                        if( typeof(respv.sub_category_id) != "undefined" && respv.sub_category_id != ''){
                            parameters.push("sub=" + respv.sub_category_id);
                            filter_element = $(".sub_category_id_filter span.content");
                            if( parseInt(filter_element.html()) == parseInt(respv.sub_category_id) && v == 'sub_categories' ){
                                filter_element.html(respv.type_name);
                            }
                        }
                        if( typeof(respv.brand_id) != "undefined" && respv.brand_id != ''){
                            parameters.push("b=" + respv.brand_id);
                            filter_element = $(".brand_id_filter span.content");
                            if( parseInt(filter_element.html()) == parseInt(respv.brand_id) && v == 'brands' ){
                                filter_element.html(respv.type_name);
                            }
                        }
                        if( typeof(respv.color) != "undefined" && respv.color != ''){
                            parameters.push("c=" + respv.color);
                        }
                        if( typeof(respv.size) != "undefined" && respv.size != ''){
                            parameters.push("s=" + respv.size);
                        }
                        if( typeof(respv.price_range) != "undefined" && respv.price_range != ''){
                            parameters.push("price_range=" + respv.price_range);
                        }
                        var div = $('<div/>', { class: 'link' });
                        var link_text = respv.type_name + (v == 'sizes' ? '' : "("+ respv.count +")");
                        div.html(
                            $('<a/>', {
                                href: '#' + parameters.join("&"),
                                text: link_text
                            })
                        ).appendTo(result_element);
                    });
                    result_container.slideDown();
                }
            });
        });
    }
}

$(function(){
  $.history.init(function(url){
    var url_parser = $.url(document.location);
    //Forcing redirect if location hash exists and page is not an Advanced Search
    if (url_parser.segment(1) != '' && url_parser.segment(1) != 'advanced_search'){
      if (url_parser.fsegment(1) != ''){
          document.location = 'http://' + document.location.host + '/#' + url_parser.fsegment().join('/');
      }
      return false;
    }
    if(url_parser.segment(1) != 'advanced_search'){
        load_categorized_or_single_page(url_parser);
    }
    else{
        load_search_page(parse_search_parameters(url_parser));
    }

  },
  { unescape: "/" });

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
    $('#search_form').submit();
    return false;
  });

  $("#search_button").click(function(event){
    event.preventDefault();
  });

  $('#search_form').submit(function(){
    var search_query = $.trim($('#search_query').val());
    if (search_query == '') return false;
    $.history.load('search/'+encodeURI(search_query)+'/');
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

  prepare_paginated_links();
  activate_price_filter();

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

function activate_price_filter(){
    var max_price = $("#max_price").html();
    var currency = $("#currency").html();
    $('#price_filter').val('0-' + max_price);
    $("#price_slider").slider({
        range:true,
        min: 0,
        max: max_price,
        values:[0, max_price],
        step: 5,
        slide: function( event, ui ) {
            $("#price_range_label").html(ui.values[ 0 ] + ' ' + currency + ' - ' + ui.values[ 1 ] + ' ' + currency);
        },
        stop: function(event, ui){
            var current_price_range = $.url(location.href).data.param.fragment.price_range;
            var current_hash = location.hash;
            var new_hash = '';
            var price_range = ui.values[0] + '-' + ui.values[1];
            if(current_hash == ''){
                new_hash = 'price_range=' + price_range;
            }
            else if(typeof(current_price_range) == 'undefined' || current_price_range == ''){
                new_hash = current_hash + '&price_range=' + price_range;
            }
            else{
                new_hash = current_hash.replace(/price_range=(\d+)-(\d+)/, 'price_range=' + price_range);
            }
            $.history.load(new_hash);
        }
    });
}

function update_filter_removal_panel(params){
    var filter = '';
    var exceptional_array = [];
    var param_to_hash_map = {
        gender_id: 'g',
        brand_id: 'b',
        category_id: 'cat',
        sub_category_id: 'sub',
        color: 'c',
        size: 's',
        price_range: 'price_range'
    };
    // Set name and url
    $.each(params, function(type, param){
        filter = $("." + type + '_filter');
        exceptional_array = [];
        if(typeof(param) != 'undefined'){
            filter.find('span.content').html(param);
            $.each(params, function(type2, param2){
                if( typeof(param2) != 'undefined' && type2 != 'page'){
                    if (param == param2 && type == type2){}
                    else exceptional_array.push(param_to_hash_map[type2] + '=' + param2);
                }
            });
            filter.find('span.content').data('url', exceptional_array.join('&'));
            filter.show();
        }
        else{
            filter.hide();
        }
    });

    // Activate
    $(".selected_filter").click(function(){
        var url = $(this).find('span.content').data().url;
        if(url == '') location.href = location.protocol + '//' + location.host + location.pathname;
        else $.history.load(url);
    });
}

