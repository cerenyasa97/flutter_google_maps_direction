import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_maps/core/components/project_text_field.dart';
import 'package:flutter_app_maps/google_maps_page/project_maps_viewmodel.dart';
import 'package:flutter_app_maps/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app_maps/google_maps_page/project_maps_model.dart';
import '../models/marker_model.dart';

class ProjectMaps extends StatefulWidget {
  @override
  ProjectMapsView createState() => new ProjectMapsView();
}

// ignore: must_be_immutable
class ProjectMapsView extends ProjectMapsViewModel {
  double height = 370;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // Triggers the method that changes the camera position when FloatingActionButton is pressed
        floatingActionButton: floatingButtons(context),
        body: _mapsBody);
  }

  Widget floatingButtons(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          icon: Icon(Icons.home),
          label: Text("Home"),
          onPressed: () => goToHome(),
        ),
        SizedBox(
          width: 5,
        ),
        FloatingActionButton.extended(
          icon: Icon(Icons.work),
          label: Text("Work"),
          onPressed: () => goToWork(),
        ),
        SizedBox(
          width: 5,
        ),
        FloatingActionButton.extended(
          icon: Icon(Icons.done),
          label: Text("Draw Route"),
          onPressed: () => getDirections(),
        )
      ],
    );
  }

  Widget get _mapsBody {
    return ValueListenableBuilder<LocationStatus>(
        valueListenable: listenableStatus,
        builder: (context, status, child) {
          switch (status) {
            case LocationStatus.SEARCHING:
              return Center(
                child: CircularProgressIndicator(),
              );
            case LocationStatus.FOUND:
              return SafeArea(
                  child: Stack(
                children: [
                  Consumer<GoogleMapsModel>(
                    builder: (context, mapModel, child) {
                      return GoogleMap(
                        zoomControlsEnabled: false,
                        myLocationEnabled: true,
                        mapType: MapType.normal,
                        polylines: mapModel.polylineSet,
                        initialCameraPosition: CameraPosition(
                            target: currentLocation.latLong, zoom: 15),
                        onMapCreated: (map) {
                          mapController = map;
                        },
                        markers: mapModel.markerMap.isNotEmpty
                            ? Set<Marker>.of(mapModel.markerMap.values)
                            : Set<Marker>(),
                      );
                    },
                  ),
                  Positioned(
                    child: ProjectTextField(
                      enabled: false,
                      controller: locationController,
                      onChanged: (text) {
                        findPlace(text);
                      },
                    ),
                    top: 80,
                    left: 25,
                    right: 25,
                  ),
                  Positioned(
                    child: ProjectTextField(
                      controller: destinationController,
                      onChanged: (text) {
                        findPlace(text);
                        height = 370;
                      },
                    ),
                    top: 140,
                    left: 25,
                    right: 25,
                  ),
                  Positioned(
                    top: 190,
                    left: 30,
                    right: 30,
                    child: ValueListenableBuilder<List<PlaceModel>>(
                      valueListenable: listenablePlaceModels,
                      builder: (context, predictionsList, child) {
                        return Visibility(
                          child: Builder(
                              builder: (context) => Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        backgroundBlendMode: BlendMode.darken),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    width: 370,
                                    height: height,
                                    child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          onTap: () {
                                            getPlaceAddressDetails(
                                                predictionsList[index].placeID);
                                            setState(() {
                                              height = 0;
                                            });
                                          },
                                          title: Text(
                                            predictionsList[index].mainText,
                                            style: TextStyle(fontSize: 14, color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            predictionsList[index]
                                                .secondaryText,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                          leading: Icon(Icons.add_location, color: Colors.white,),
                                        );
                                      },
                                      itemCount: predictionsList.length,
                                      separatorBuilder: (context, index) {
                                        return Divider(
                                            height: 1, color: Colors.grey);
                                      },
                                    ),
                                  )),
                          visible: predictionsList.isNotEmpty,
                        );
                      },
                    ),
                  ),
                ],
              ));
            default:
              return Center(
                child:
                    Text("Error occured please close the app and open again"),
              );
          }
        });
  }
}
