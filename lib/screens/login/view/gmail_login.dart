import 'package:piton_taxi_app/core/extensions/project_context_extension.dart';
import 'package:piton_taxi_app/core/constants/constants.dart';
import 'package:flutter/material.dart';

class GmailLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.dynamicWidth(50/412),
      height: context.dynamicWidth(50/412),
      child: Image.asset(googleLoginImage, fit: BoxFit.fill,),
    );
  }
}
