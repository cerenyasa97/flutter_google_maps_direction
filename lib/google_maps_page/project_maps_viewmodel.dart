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
  // Holds the enum variable that checks the status of currentLocation whose initial value is being searching
  ValueNotifier<LocationStatus> status = ValueNotifier<LocationStatus>(LocationStatus.SEARCHING);
  List<Marker> markers = [];

  ProjectMapsViewModel(){
    fetchCurrentLocation();
  }

  //Captures the currentLocation value and changes the value of status and passes the last status to the Builder.
  fetchCurrentLocation() async {
    try{
      currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentLocation = ProjectMapModel(currentPosition.latitude, currentPosition.longitude, "Current Location").latLong;
      status.value = LocationStatus.FOUND;
    }catch(e){
      status.value = LocationStatus.ERROR;
    }
  }

  //Adjusts the camera position to the given static LatLng value
  goToWork() {
    ProjectMapModel work = ProjectMapModel(39.7826023, 30.5082429, "Work");
    markers = [Marker(markerId: MarkerId(work.name), position: work.latLong)];
    mapController.animateCamera(CameraUpdate.newLatLng(work.latLong));
  }
}