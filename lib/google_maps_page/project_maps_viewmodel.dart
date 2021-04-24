import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app_maps/google_maps_page/project_maps_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum LocationStatus{SEARCHING, FOUND, ERROR}

// ignore: must_be_immutable
abstract class ProjectMapsViewModel extends StatelessWidget{
  GoogleMapController mapController;
  Position currentPosition;
  LatLng currentLocation;

  // Variable showing the status of receiving location information when the application is opened
  ValueNotifier<LocationStatus> listenableStatus = ValueNotifier<LocationStatus>(LocationStatus.SEARCHING);

  Map<MarkerId, Marker> markersMap = Map<MarkerId, Marker>();
  // ignore: close_sinks
  StreamController<Map<MarkerId, Marker>> markerStreamController = StreamController<Map<MarkerId, Marker>>();
  Stream<Map<MarkerId, Marker>> get markerStream => markerStreamController.stream;

  List<ProjectMapModel> addressList = [
    ProjectMapModel(39.7858289, 30.468587, "1"),
    ProjectMapModel(39.781794, 30.468425, "2"),
    ProjectMapModel(39.780571, 30.4552115, "3"),
    ProjectMapModel(39.782041, 30.450113, "4"),
    ProjectMapModel(39.785458, 30.453385, "5"),
  ];

  ProjectMapsViewModel(){
    fetchCurrentLocation();
    markerStreamController.sink.add(markersMap);
  }

  //Captures the currentLocation value and changes the value of status and passes the last status to the Builder.
  fetchCurrentLocation() async {
    try{
      currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentLocation = ProjectMapModel(currentPosition.latitude, currentPosition.longitude, "Current Location").latLong;
      listenableStatus.value = LocationStatus.FOUND;
    }catch(e){
      listenableStatus.value = LocationStatus.ERROR;
    }
  }

  // Turns the camera  position to the work and adds a marker
  goToWork() {
    ProjectMapModel work = ProjectMapModel(39.7826023, 30.5082429, "Work");
    createLocationMarker(work);
    animateCameraNewLatLng(work);
  }

  // Turns the camera  position to the school and adds a marker
  goToSchool(){
    ProjectMapModel school = ProjectMapModel(39.7720233, 30.5026506, "school");
    createLocationMarker(school);
    animateCameraNewLatLng(school);
  }

  // Dynamically creates a marker and adds it to the marker Set. Each marker ID is unique, as the markers are added according to the id.
  void createLocationMarker(ProjectMapModel model) {
    final markerID = MarkerId(model.toString());
    final marker = Marker(markerId: markerID, position: model.latLong);
    markersMap[markerID] = marker;
    markerStreamController.sink.add(markersMap);
  }

  // Turns the camera position
  void animateCameraNewLatLng(ProjectMapModel work) {
    mapController.animateCamera(CameraUpdate.newLatLng(work.latLong));
  }

  // Returns static marker list
  addMarker() {
    return addressList.map((e) => Marker(markerId: MarkerId(e.hashCode.toString()), position: e.latLong)).toSet();
  } 
}