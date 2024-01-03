import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String textHint;
  final bool obsureText;

  MyTextField(
      {Key? key,
      required this.controller,
      required this.textHint,
      required this.obsureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          )
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white
            ),
        ),
        hintText: textHint,
        filled: true,
        fillColor: Colors.grey[200]
      ),
    );
  }
}
