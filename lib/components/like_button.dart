import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final void Function()? onTap;
  LikeButton({Key? key, required this.onTap, required this.isLiked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Icon(isLiked? Icons.favorite : Icons.favorite_border,
        color: isLiked? Colors.red : Colors.grey,),
      ),
    );
  }
}
