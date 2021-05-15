import 'package:flutter/material.dart';
import 'package:flutter_app_maps/data_handler/route_data.dart';
import 'package:flutter_app_maps/models/marker_model.dart';
import 'package:flutter_app_maps/google_maps_page/project_maps_view.dart';
import 'package:provider/provider.dart';

import 'google_maps_page/project_maps_viewmodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<GoogleMapsModel>(create: (context) => GoogleMapsModel()),
          ChangeNotifierProvider<RouteData>(create: (context) => RouteData()),
        ],
        child: ProjectMaps(),
      )
    );
  }
}