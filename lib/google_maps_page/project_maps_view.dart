import 'package:flutter/material.dart';
import 'package:flutter_app_maps/google_maps_page/project_maps_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class ProjectMapsView extends ProjectMapsViewModel{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Triggers the method that changes the camera position when FloatingActionButton is pressed
        floatingActionButton: floatingButtons(context),
        body: _mapsBody);
  }

  Widget floatingButtons(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          child: Icon(Icons.work),
          onPressed: () => goToWork(),
        ),
        FloatingActionButton(
          child: Icon(Icons.school),
          onPressed: () => goToSchool(),
        )
      ],
    );
  }

  SafeArea get _mapsBody {
    return SafeArea(
      child: Stack(
        children: [
          // Builder that listens to status and returns different widgets based on currentLocation's state
          ValueListenableBuilder<LocationStatus>(
              valueListenable: listenableStatus,
              builder: (context, status, child) {
                switch (status) {
                  case LocationStatus.SEARCHING:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case LocationStatus.FOUND:
                    return StreamBuilder(builder: (context, markerSnapshot){
                      return GoogleMap(
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                              target: currentLocation, zoom: 15),
                          onMapCreated: (map) {
                            mapController = map;
                          },
                          markers: Set<Marker>.of(markerSnapshot.data.isNotEmpty
                              ? markerSnapshot.data.values
                              : <Marker>[]),
                        );
                    },
                    stream: markerStream,
                    );
                  default:
                    return Center(
                      child: Text(
                          "Error occured please close the app and open again"),
                    );
                }
              })
        ],
      ),
    );
  }
}
