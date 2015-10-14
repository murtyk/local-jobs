function add_markers_to_map(markers_json, click_function){
  var handler = Gmaps.build('Google');

  handler.buildMap({ internal: {id: 'map'}}, function(){
    var markers = handler.addMarkers(markers_json);
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
    add_click_events(markers, click_function);
  });
}

function add_click_events(markers, click_function){
  var event = google.maps.event;
  $.each(markers, function( index, marker ) {
    event.addListener(marker.serviceObject, 'click', function() {
      click_function(this);
    });
  });
}

Number.prototype.round = function(places) {
  return +(Math.round(this + "e+" + places)  + "e-" + places);
}