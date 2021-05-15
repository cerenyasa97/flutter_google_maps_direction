class AddressDetailsModel{
  String placeID;
  String name;
  double lat;
  double lng;

  AddressDetailsModel(this.placeID, this.name, this.lat, this.lng);

  AddressDetailsModel.fromJson(Map<String, dynamic> json){
    this.placeID = json["place_id"];
    this.name = json["name"];
    this.lat = json["lat"];
    this.lng = json["lng"];
  }

  @override
  String toString() {
    return 'AddressDetailsModel{placeID: $placeID, name: $name, lat: $lat, lng: $lng}';
  }
}