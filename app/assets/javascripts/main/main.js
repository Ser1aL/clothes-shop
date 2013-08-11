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
    location.href = location.protocol + '//' + location.host + '/#search/'+encodeURI(search_query)+'/';
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

  $('.mcl_show_more').click(function(event){
      event.preventDefault();
      $(this).closest('ul').find('.hidden_link').removeClass('hidden_link');
      $(this).remove();
  });

  activate_selection_popups();
  if($('#flash_message').length > 0) $('#flash_message').modal();

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

  prepare_paginated_links();
  activate_price_filter();
  prepare_ajaxified_links();
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

function init_slider(){
    $('#slides').slides({
        play: 4000,
        pause: 2500
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
            var current_uri = $('.price_filter_container').data('current_uri');
            location.href = current_uri.replace(/\&price_range=\d+\-\d+/, '') + '&price_range=' + price_range;
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


function prepare_paginated_links(page_type){
    // skip articles pager and categories page
    if($(".articles").length > 0 || $('.category-page').length > 0) return;
    if(page_type != 'cat' && page_type != 'search') {
        var page = '';
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
    if(page_type == 'search') {
        $.each($(".pager a"), function(index, pager_url) {
            var url = $.url(this.href);
            var page = url.param('page') == undefined ? 1 : parseInt(url.param('page'));
            var search_query = url.param('search_query') == undefined ? '' : url.param('search_query');
            $(pager_url).attr('href', '#' + page_type + '/' + search_query + '/' + page);
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
        // else it is an advanced search
        else return true;
        return false;
    });
    prepare_ajaxified_links();
}

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

function load_categorized_or_single_page(url_parser){
    var script_name = '/';
    var query = '';
    var page_type = url_parser.fsegment(1);
    if (page_type == '') { return true; }

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
        $.each(params, function(key, value){
            if(typeof(value) != 'undefined' && key != 'page') initialized_params_count += 1;
        });
        update_filter_removal_panel(params);
        if(initialized_params_count > 0) $(".selected_filters .hint").show(); else $(".selected_filters .hint").hide();
        var sections = ["categories", "genders", "sub_categories", "brands"];

        if(initialized_params_count >= 3){
            sections.push("sizes");
            sections.push("colors");
            $(".price_filter_container").slideDown();
        }
        else if(initialized_params_count == 2){
            sections.push("colors");
        }
        else{
            $(".price_filter_container").slideUp();
        }

        $.each(sections, function(k, v){
            $("."+v+" .content .main_category").html("<div class='loader'></div>");
            $.ajax({
                url : "/search/preload_" + v,
                data : params
            }).success(function(resp){
                    result_container = $("."+v);
                    result_element = $("."+v+" .content .main_category");
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
                                    filter_element.html($('<div/>').html(respv.type_name).text());
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
                            if(respv.action != 'preload_colors') {
                                var li = $('<li/>', { class: 'mcl_link' });
                                if(k > 4) li.addClass('hidden_link');

                                li.append($('<a/>', {
                                    href: '#' + parameters.join("&"),
                                    text: respv.type_name,
                                    class: 'mcl_link_left'
                                }));

                                li.append($('<a/>', {
                                    href: '#' + parameters.join("&"),
                                    text: v == 'sizes' ? '' : "("+ respv.count +")",
                                    class: 'mcl_link_right'
                                }));

                                li.appendTo(result_element);
                            }
                            else {
                                var image_div = $('<div/>', { class: 'image_div' });
                                if(respv.swatch_url != null){
                                    image_div.html(
                                        $('<a/>', {
                                            href: '#' + parameters.join("&")
                                        }).append($("<img/>", { src: respv.swatch_url }))
                                    ).appendTo(result_element);
                                }
                            }
                        });
                        result_container.slideDown();
                    }
                });
        });
    }
}
