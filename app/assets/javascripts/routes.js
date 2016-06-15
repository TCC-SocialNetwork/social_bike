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

  $("#save").hide();
}

$('#view_route').click(function() {
  points = [];
  var origin = $('#origin').val();
  var destination = $('#destination').val();

  travelMode = getModeOfTravel($('#travel_mode').val());

  var waypoints = [];
  var result = request_map(origin, destination, travelMode, waypoints, callback_to_create)
  console.log("Antes")
  console.log(result)
  
});

function request_map(origin, destination, travelMode, waypoints, callback){
  var request = {
    origin: origin,
    destination: destination,
    waypoints: waypoints,
    travelMode: travelMode
  };

  directionsService.route(request, callback);
}

function callback(result, status) {
  if (status == google.maps.DirectionsStatus.OK) {
    directionsDisplay.setDirections(result); // Render result
  }
}

function callback_to_create(result, status) {
  if (status == google.maps.DirectionsStatus.OK) {
    directionsDisplay.setDirections(result); // Render result
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
}

function getModeOfTravel(modeOfTravel){
  var travelMode = google.maps.TravelMode.DRIVING;

  if (modeOfTravel == "Bicicleta")
    travelMode = google.maps.TravelMode.BICYCLING;
  else if (modeOfTravel == "A Pé")
    travelMode = google.maps.TravelMode.WALKING;
  else if (modeOfTravel == "Transporte Público")
    travelMode = google.maps.TravelMode.TRANSIT;

  return travelMode;
}

initialize();

if($("#map").hasClass("show_route")){
  var locations = $('.locations').data('locations');
  var origin = $('.origin').data('origin');
  origin = origin.latitude + ", " + origin.longitude
  var destination = $('.destination').data('destination');
  destination = destination.latitude + ", " + destination.longitude
  console.log($('.travel').data('travel'));
  var travelMode = getModeOfTravel($('.travel').data('travel'));

  console.log(locations);
  console.log(origin);
  console.log(destination);
  console.log(travelMode);
  request_map(origin, destination, travelMode, locations, callback)
}
