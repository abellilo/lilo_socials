import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onTap;
  MyTextBox({Key? key, required this.text, required this.sectionName, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8)
      ),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: EdgeInsets.only(left: 15,bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //section name
              Text(sectionName,style: TextStyle(
                color: Colors.grey[500]
              ),),

              //edit button
              IconButton(onPressed: onTap, icon: Icon(Icons.settings, color: Colors.grey[400],))
            ],
          ),

          //text
          Text(text)
        ],
      ),
    );
  }
}
