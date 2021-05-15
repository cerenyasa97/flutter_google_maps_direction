import 'package:flutter/cupertino.dart';
import 'package:flutter_app_maps/google_maps_page/project_maps_model.dart';

class RouteData extends ChangeNotifier{
  ProjectMapModel initialAddress, destinationAddress;

  updateInitialAddress(ProjectMapModel address){
    initialAddress = address;
    notifyListeners();
  }

  updateDestinationAddress(ProjectMapModel address){
    destinationAddress = address;
    notifyListeners();
  }

}