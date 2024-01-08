import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lilo_socials/components/comment.dart';
import 'package:lilo_socials/components/comment_button.dart';
import 'package:lilo_socials/components/delete_button.dart';
import 'package:lilo_socials/components/like_button.dart';
import 'package:lilo_socials/helper/helper_method.dart';

class Post extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List likes;
  final String time;

  Post(
      {Key? key,
      required this.time,
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

  //comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  //toggle like
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //access the document in firebase
    DocumentReference reference =
        FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if (isLiked) {
      //if liked add the user email to the liked list
      reference.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      //if the post is now unliked remove the user email from the list
      reference.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  //add comment
  void addComment(String commentText) {
    //write the comment to firestore under the comment collection for this post
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      'CommentText': commentText,
      'CommentedBy': currentUser.email,
      'CommentTime': Timestamp.now() // remember to format this when in display
    });
  }

  //show a dialogue box for adding a comment
  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[200],
            title: Text("Add Comment"),
            content: TextField(
              controller: _commentTextController,
              autofocus: true,
              decoration: InputDecoration(hintText: "Write a comment..."),
            ),
            actions: [
              //cancel button
              TextButton(
                  onPressed: () {
                    //pop box
                    Navigator.of(context).pop();

                    //clear controller
                    _commentTextController.clear();
                  },
                  child: Text("Cancel",style: TextStyle(
                    color: Colors.black
                  ),)),

              //post button
              TextButton(
                  onPressed: () {
                    //add comment
                    addComment(_commentTextController.text);

                    //pop box
                    Navigator.of(context).pop();

                    //clear controller
                    _commentTextController.clear();
                  },
                  child: Text("Post",style: TextStyle(
                    color: Colors.brown[800]
                  ),)),
            ],
          );
        });
  }

  //delete post
  Future<void> deletePost() async {
    showDialog(
        context: context,
        builder: (cxt) => AlertDialog(
              backgroundColor: Colors.grey[200],
              title: Text("Delete Post"),
              content: Text("Are you sure you want to delete this post"),
              actions: [
                //cancel button
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Cancel",style: TextStyle(
                        color: Colors.black
                    ))),

                //delete button
                TextButton(
                    onPressed: () async {
                      //delete comment
                      final commentDocs = await FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .collection("Comments")
                          .get();

                      for (var doc in commentDocs.docs) {
                        await FirebaseFirestore.instance
                            .collection("User Posts")
                            .doc(widget.postId)
                            .collection("Comments")
                            .doc(doc.id)
                            .delete();
                      }

                      //delete post
                      await FirebaseFirestore.instance
                          .collection("User Posts")
                          .doc(widget.postId)
                          .delete().then((value) => print("post deleted"))
                          .catchError(
                              (error) => print("Failed to delete post "+error.toString()));

                      //pop box
                      Navigator.pop(cxt);
                    },
                    child: Text("Delete",style: TextStyle(
                      color: Colors.red
                    ),)),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //post
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //message
                    Text(widget.message),
                    const SizedBox(
                      height: 10,
                    ),
                    //user
                    Text(
                      widget.user,
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    //time
                    Text(
                      widget.time,
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),

              //delete button
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost)
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          //like button & like count
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  //like button
                  LikeButton(onTap: toggleLike, isLiked: isLiked),

                  //like count
                  Text(
                    widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  //comment button
                  CommentButton(onTap: showCommentDialog),

                  //comment count
                  // Text(
                  //   "0",
                  //   style: TextStyle(color: Colors.grey),
                  // )
                ],
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          //display comments
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .orderBy('CommentTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      final commentData = doc.data() as Map<String, dynamic>;
                      return Comment(
                          user: commentData['CommentedBy'],
                          text: commentData['CommentText'],
                          time: formatData(commentData['CommentTime']));
                    }).toList(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error " + snapshot.hasError.toString()),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              })
        ],
      ),
    );
  }
}
