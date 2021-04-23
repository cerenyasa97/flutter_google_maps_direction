import 'package:flutter/material.dart';
import 'package:flutter_app_maps/google_maps_page/project_maps_view.dart';
import 'package:flutter_app_maps/google_maps_page/project_maps_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  ProjectMapsView(),
    );
  }
}