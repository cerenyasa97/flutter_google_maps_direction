import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_maps/google_maps_page/project_maps_model.dart';
import 'package:flutter_app_maps/google_maps_page/project_maps_view.dart';
import 'package:flutter_app_maps/map_api_key.dart';
import 'package:flutter_app_maps/models/direction_model.dart';
import 'package:flutter_app_maps/models/place_model.dart';
import 'package:flutter_app_maps/services/api_service.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

import '../models/marker_model.dart';

enum LocationStatus { SEARCHING, FOUND, ERROR }

// ignore: must_be_immutable
abstract class ProjectMapsViewModel extends State<ProjectMaps> {
  GoogleMapController mapController;
  Position currentPosition;
  ProjectMapModel currentLocation;
  ProjectMapModel destinationLocation;
  GoogleMapsModel markerModel;
  MarkerId markerId;

  // Variable showing the status of receiving location information when the application is opened
  ValueNotifier<LocationStatus> listenableStatus =
      ValueNotifier<LocationStatus>(LocationStatus.SEARCHING);

  ValueNotifier<List<PlaceModel>> listenablePlaceModels =
      ValueNotifier<List<PlaceModel>>([]);

  final TextEditingController locationController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  ProjectMapsViewModel() {
    fetchCurrentLocation();
  }

  //Captures the currentLocation value and changes the value of status and passes the last status to the Builder.
  fetchCurrentLocation() async {
    try {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentLocation = ProjectMapModel(
          "current_location",
          currentPosition.latitude,
          currentPosition.longitude,
          "Current Location");
      final List<Placemark> placemark = await placemarkFromCoordinates(
          currentLocation.lat, currentLocation.long);
      locationController.text =
          placemark.first.thoroughfare + " / No: " + placemark.first.name;
      listenableStatus.value = LocationStatus.FOUND;
    } catch (e) {
      listenableStatus.value = LocationStatus.ERROR;
    }
  }

  // Turns the camera  position to the work and adds a marker
  goToHome() async {
    final pm = await locationFromAddress(
        "Eti Cd., Yenibağlar, 26170 Tepebaşı/Eskişehir",
        localeIdentifier: "TR");
    final home =
        ProjectMapModel("home", pm.first.latitude, pm.first.longitude, "Home");
    addMarker(home);
    animateCameraNewLatLng(home);
  }

  // Turns the camera  position to the school and adds a marker
  goToWork() async {
    final pm = await locationFromAddress(
        "Eskibağlar, Yılmaz Büyükerşen Blv No:21, 26170 Tepebaşı/Eskişehir");
    final work =
        ProjectMapModel("work", pm.first.latitude, pm.first.longitude, "work");
    addMarker(work);
    animateCameraNewLatLng(work);
  }

  // Delete before position's marker and add new marker for new position
  void addMarker(ProjectMapModel place) {
    markerModel = Provider.of<GoogleMapsModel>(context, listen: false);
    if (markerId != null) markerModel.deleteMarker(markerId);
    markerId = markerModel.addMarker(place);
  }

  // Turns the camera position
  void animateCameraNewLatLng(ProjectMapModel work) {
    mapController.animateCamera(CameraUpdate.newLatLng(work.latLong));
  }

  // Gets predictions from the API for the address the user will enter
  findPlace(String inputPlace) async {
    if (inputPlace.length > 1) {
      final String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputPlace&key=$API_KEY&sessiontoken=1234567890&components=country:tr";
      final result = await ApiService.getRequest(autoCompleteUrl);
      listenablePlaceModels.value = (result["predictions"] as List)
          .map((e) => PlaceModel.fromJson(e))
          .toList();
    }
  }

  // Retrieves the details of the user's chosen address from the API
  getPlaceAddressDetails(String placeID) async {
    final String placeAddressDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$API_KEY";
    final result = await ApiService.getRequest(placeAddressDetailsUrl);
    final location = result["result"]["geometry"]["location"];
    final ProjectMapModel selectedPlace = ProjectMapModel(
        placeID, location["lat"], location["lng"], result["result"]["name"]);
    destinationLocation = selectedPlace;
    destinationController.text = selectedPlace.name;
    animateCameraNewLatLng(selectedPlace);
    addMarker(selectedPlace);
  }

  // Makes a request to the API to get Direction information and calls the method that draws the route with this returning response
  getDirections() async {
    final String directionsUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${currentLocation.lat},${currentLocation.long}&destination=${destinationLocation.lat},${destinationLocation.long}&key=$API_KEY";
    var result = await ApiService.getRequest(directionsUrl);
    final encodedPoints = result["routes"][0]["overview_polyline"]["points"];
    final distanceText = result["routes"][0]["legs"][0]["distance"]["text"];
    final distance = result["routes"][0]["legs"][0]["distance"]["value"];
    final durationText = result["routes"][0]["legs"][0]["duration"]["text"];
    final duration = result["routes"][0]["legs"][0]["duration"]["value"];
    DirectionModel model = DirectionModel(
        distanceText, durationText, encodedPoints, distance, duration);
    drawPolyLine(model.encodedPoints);
  }

  // Decode the points in encoded points taken from the direction details to take their latitudes and longitudes
  // Creates polyline with this location list
  drawPolyLine(String encodedPoints) {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePoints =
        polylinePoints.decodePolyline(encodedPoints);
    if (decodedPolylinePoints.isNotEmpty) {
      decodedPolylinePoints.forEach((pointLatLng) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    Provider.of<GoogleMapsModel>(context, listen: false).clearPolyline();
    Polyline polyline = Polyline(
      color: Colors.amber,
      polylineId: PolylineId("PolylineId"),
      jointType: JointType.round,
      points: polylineCoordinates,
      width: 3,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );
    Provider.of<GoogleMapsModel>(context, listen: false).addPolyline(polyline);

    latLongBounds();
  }

  // Sets borders by selecting the closest positions from 4 sides to the initial and
  // destination locations to find the closest route while drawing the polyline
  latLongBounds() {
    LatLngBounds latLngBounds;
    if (currentLocation.lat > destinationLocation.lat &&
        currentLocation.long > destinationLocation.long) {
      latLngBounds = LatLngBounds(
          southwest: destinationLocation.latLong,
          northeast: currentLocation.latLong);
    } else if (currentLocation.lat > destinationLocation.lat) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(destinationLocation.lat, currentLocation.long),
          northeast: LatLng(currentLocation.lat, destinationLocation.long));
    } else if (currentLocation.long > destinationLocation.long) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(currentLocation.lat, destinationLocation.long),
          northeast: LatLng(destinationLocation.lat, currentLocation.long));
    } else {
      latLngBounds = LatLngBounds(
          southwest: currentLocation.latLong,
          northeast: destinationLocation.latLong);
    }

    mapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
  }
}
