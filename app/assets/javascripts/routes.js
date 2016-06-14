var geocoder;
var map;
var marker;
var directionsDisplay;
var directionsService;
var points = [];

function initialize() {
  geocoder = new google.maps.Geocoder();
  directionsDisplay = new google.maps.DirectionsRenderer();
  directionsService = new google.maps.DirectionsService();

  var latlng = new google.maps.LatLng(-15.989449,-48.045481);
  var options = {
    zoom: 5,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  map = new google.maps.Map(document.getElementById("map"), options);
  directionsDisplay.setMap(map);

  /*marker = new google.maps.Marker({
      map: map,
      draggable: true,
  });*/

  $("#save").hide();
}

initialize();

$('#view_route').click(function() {
  points = [];
  var origin = $('#origin').val();
  var destination = $('#destination').val();

  var travelMode = google.maps.TravelMode.DRIVING

  if ($('#travel_mode').val() == "Bicicleta")
    travelMode = google.maps.TravelMode.BICYCLING
  else if ($('#travel_mode').val() == "A Pé")
    travelMode = google.maps.TravelMode.WALKING
  else if ($('#travel_mode').val() == "Transporte Público")
    travelMode = google.maps.TravelMode.TRANSIT

  var request = {
    origin: origin,
    destination: destination,
    // waypoints: [{location: "-15.795940000000002,-47.866440000000004"}, {location: "-15.792520000000001,-47.876900000000006"}],
    travelMode: travelMode
  };

  
  directionsService.route(request, function(result, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      for (i = 0; i < result.routes[0].overview_path.length; i++) {
        points.push({latitude: result.routes[0].overview_path[i].lat().toFixed(15), 
                     longitude: result.routes[0].overview_path[i].lng().toFixed(15)});
      }
      
      $("#points").val(JSON.stringify(points, null, 2));

      var distance = 0;
      for (var i = 0; i < result.routes[0].legs.length; i++) {
        distance += result.routes[0].legs[i]["distance"]["value"];
      }

      $("#distance").val(distance);

      $("#save").show();
      directionsDisplay.setDirections(result); // Render result
    }
  });
});
