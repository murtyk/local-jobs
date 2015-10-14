function autocomplete_city(city_element_id){
  var options = {types: ['(cities)'], componentRestrictions: {country: "us"}};
  var input = document.getElementById(city_element_id);
  var autocomplete = new google.maps.places.Autocomplete(input,options);
  google.maps.event.addListener(autocomplete, 'place_changed', function(){
     var place = autocomplete.getPlace();
  })
}

$(document).bind('DOMNodeInserted', function(event) {
  var target = $(event.target);
  if (target.hasClass('pac-item')){
    // replacing "City, State United States" to "City, State" for each list element
    // warning: on click it will still autofill input with "Some City, United Kingdom"
    target.html(target.html().replace(/, United States<\/span>$/, "</span>"))
  }
});
