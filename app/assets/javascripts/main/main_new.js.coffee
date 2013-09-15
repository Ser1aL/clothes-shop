$ ->
  $('.submit_search').click -> $('#search_form').submit()



#  $('.submit_search').click(function(){
#  $('#search_form').submit();
#  return false;
#  });
#
#  $("#search_button").click(function(event){
#  event.preventDefault();
#  });
#
#  $('#search_form').submit(function(){
#  var search_query = $.trim($('#search_query').val());
#    if (search_query == '') return false;
#  location.href = location.protocol + '//' + location.host + '/#search/'+encodeURI(search_query)+'/';
#  $('#loader').show();
#  });