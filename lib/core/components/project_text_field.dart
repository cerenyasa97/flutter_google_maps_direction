import 'package:flutter/material.dart';

class ProjectTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final bool enabled;

  const ProjectTextField(
      {Key key,
      @required this.controller,
      this.hintText,
      this.onChanged,
      this.onSubmitted, this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0x29000000),
              offset: Offset(0, 3),
              blurRadius: 10,
            ),
          ]),
      child: TextField(
        enabled: enabled ?? true,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(width: 2, color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(width: 2, color: Colors.white)),
          contentPadding: EdgeInsets.symmetric(horizontal: 5),
          hintText: hintText ?? "Hint",
        ),
        controller: controller,
        onChanged: (text) => onChanged(text),
        onSubmitted: (text) => onSubmitted(text),
      ),
    );
  }
}
