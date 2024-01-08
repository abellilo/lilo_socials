import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  Comment(
      {Key? key, required this.user, required this.text, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4)
      ),
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //comments
          Text(text),

          //user, time
          Text(user,style: TextStyle(
              color: Colors.grey[400],
            fontSize: 10
          ),),
          Text(time,style: TextStyle(
              color: Colors.grey[400],
              fontSize: 7
          ),),
        ],
      ),
    );
  }
}
