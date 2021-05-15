import 'package:flutter/cupertino.dart';
import 'package:flutter_app_maps/google_maps_page/project_maps_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsModel extends ChangeNotifier{
  Map<MarkerId, Marker> markerMap = Map<MarkerId, Marker>();
  Set<Polyline> polylineSet = {};

  addMarker(ProjectMapModel place){
    final key = MarkerId(place.placeID);
    markerMap[key] = Marker(markerId: MarkerId(place.placeID), position: place.latLong);
    notifyListeners();
    return key;
  }

  deleteMarker(MarkerId markerId){
    markerMap.remove(markerId);
    notifyListeners();
  }

  addPolyline(Polyline polyline){
    polylineSet.add(polyline);
    notifyListeners();
  }

  clearPolyline(){
    polylineSet.clear();
    notifyListeners();
  }

}