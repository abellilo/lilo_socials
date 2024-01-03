import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lilo_socials/components/like_button.dart';

class Post extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  Post(
      {Key? key,
      required this.message,
      required this.user,
      required this.likes,
      required this.postId})
      : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  //toggle like
  void toggleLike(){
    setState(() {
      isLiked = !isLiked;
    });

    //access the document in firebase
    DocumentReference reference = FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if(isLiked){
      //if liked add the user email to the liked list
      reference.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    }else{
      //if the post is now unliked remove the user email from the list
      reference.update({
        'Likes' : FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Column(
            children: [
              //like button
              LikeButton(onTap: toggleLike, isLiked: isLiked),

              //like count
              Text(widget.likes.length.toString(),style: TextStyle(
                color: Colors.grey
              ),)
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(widget.message),
            ],
          ),
        ],
      ),
    );
  }
}
