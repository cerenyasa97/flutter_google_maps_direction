import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProjectMapModel {
  String placeID;
  double lat;
  double long;
  String name;

  ProjectMapModel(this.placeID, this.lat, this.long, this.name);

  ProjectMapModel.fromJson(Map<String, dynamic> json)
      : placeID = json["placeID"],
        lat = json["lat"],
        long = json["lng"],
        name = json["name"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["lat"] = lat;
    map["long"] = long;
    map["name"] = name;
    return map;
  }
}

extension LatLongExtension on ProjectMapModel {
  LatLng get latLong => LatLng(this.lat, this.long);
}
