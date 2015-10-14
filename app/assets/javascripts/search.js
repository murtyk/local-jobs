autocomplete_city('q_location');
markers= $('#markers-div').data('markers')
function marker_click_handler(marker){
  var pos = marker.getPosition();
  var lat = pos.lat();
  var lng = pos.lng();
  var p_lat;
  var p_lng;
  $('.marker').each(function(){
    p_lat = $(this).attr('lat');
    p_lng = $(this).attr('lng');
    if(lat.round(2) == p_lat && lng.round(2) == p_lng){
      $(this).css("background-color","yellow");
    }
    else{
      $(this).css("background-color","white");
    }
  });
}
if (markers){ add_markers_to_map(markers, marker_click_handler); }

