import 'package:flutter/material.dart';
import 'package:flutter_app_maps/google_maps_page/project_maps_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class ProjectMapsView extends ProjectMapsViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Triggers the method that changes the camera position when FloatingActionButton is pressed
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.work),
        onPressed: () => goToWork(),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Builder that listens to status and returns different widgets based on currentLocation's state
            ValueListenableBuilder(valueListenable: status, builder: (context, status, child){
              switch(status){
                case LocationStatus.SEARCHING:
                  return Center(child: CircularProgressIndicator(),);
                case LocationStatus.FOUND:
                  return GoogleMap(
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(target: currentLocation, zoom: 15),
                    onMapCreated: (map) {
                      mapController = map;
                    },
                    markers: Set.from(markers),
                  );
                default:
                  return Center(child: Text("Error occured please close the app and open again"),);
              }
            })
          ],
        ),
      )
    );
  }
}

/*




 */