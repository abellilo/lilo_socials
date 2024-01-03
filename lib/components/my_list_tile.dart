import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;

  MyListTile(
      {Key? key, required this.text, required this.icon, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        onTap:onTap,
        leading: Icon(icon, color: Colors.white,),
        title: Text(text, style: TextStyle(
            color: Colors.white
        ),),
      ),
    );
  }
}
