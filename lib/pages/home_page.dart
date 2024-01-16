import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lilo_socials/auth/auth_service/auth_service.dart';
import 'package:lilo_socials/components/drawer.dart';
import 'package:lilo_socials/components/my_textfield.dart';
import 'package:lilo_socials/components/posts.dart';
import 'package:lilo_socials/helper/helper_method.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //current user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //text controller
  final textController = TextEditingController();

  bool loading = true;

  //logout
  void logout() async {
    try {
      setState((){
        loading = false;
      });
      //declare auth service
      final authService = AuthService();
      await authService.signOut();
      setState((){
        loading = true;
      });
    } on FirebaseAuthException catch (e) {
      setState((){
        loading = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
    }
  }

  //post message method
  void postMessage() {
    //only post something is there is something in the textfield
    if(textController.text.isNotEmpty){
      //store to firebasefirestore
      FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail" : currentUser.email,
        "Message" : textController.text,
        "Timestamp" : Timestamp.now(),
        "Likes" : []
      });

      //clear textfield after sending post
      setState(() {
        textController.clear();
      });
    }
  }

  //navigate to profile page
  void goToProfilePage(){
    // pop the drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ProfilePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return loading ?Scaffold(
      backgroundColor: Colors.brown[300],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        centerTitle: true,
        title: Text(
          "Lilo Socials",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOutTap: logout,
      ),
      body: Center(
        child: Column(
          children: [
            //the wall
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("Timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                          //get the message
                          final post = snapshot.data!.docs[index];
                          return Post(message: post['Message'],
                              user: post['UserEmail'],
                            postId: post.id,
                            time: formatData(post['Timestamp']),
                            likes: post['Likes'],
                          );
                        }
                    );
                  }
                  if(snapshot.hasError){
                    return Center(
                      child: Text("Error"+ snapshot.error.toString()),
                    );
                  }
                  return const Center(child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                },
              ),
            ),

            //post message
            Container(
              color: Colors.brown[800],
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: textController,
                            textHint: "Write something on the wall..",
                            obsureText: false,
                          ),
                        ),

                        //post button
                        IconButton(
                            onPressed: postMessage, icon: Icon(Icons.arrow_circle_up,color: Colors.white,size: 35,))
                      ],
                    ),
                  ),

                  //logged in as
                  Text("Logged in as " + currentUser.email!,style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),)
                ],
              ),
            ),
          ],
        ),
      ),
    )
    : Scaffold(
      backgroundColor: Colors.brown[300],
      body: Center(
        child: SpinKitChasingDots(
          size: 150,
          color: Colors.white,
        ),
      ),
    );
  }
}
