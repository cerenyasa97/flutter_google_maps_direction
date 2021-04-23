import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProjectMapModel{
  double lat;
  double long;
  String name;

  ProjectMapModel(this.lat, this.long, this.name);

  ProjectMapModel.fromJson(Map<String, dynamic> json) : lat = json["lat"], long = json["long"], name = json["name"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["lat"] = lat;
    map["long"] = long;
    map["name"] = name;
    return map;
  }
}

extension LatLongExtension on ProjectMapModel{
  LatLng get latLong => LatLng(this.lat, this.long);
}