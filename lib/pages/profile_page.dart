import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lilo_socials/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //get current user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //all users
  final userCollections = FirebaseFirestore.instance.collection("Users");

  //edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (cxt) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              "Edit " + field,
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              autofocus: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: "Enter new $field",
                  hintStyle: TextStyle(color: Colors.grey)),
              onChanged: (value) {
                newValue = value;
              },
            ),
            actions: [
              //cancel button
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  )),

              //save button
              TextButton(
                  onPressed: () => Navigator.of(context).pop(newValue),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          );
        });

    //update in firestore
    if(newValue.trim().isNotEmpty){
      //only update is there is something in the textfield
      await userCollections.doc(currentUser.email).update({
        field : newValue
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          //get data
          if (snapshot.hasData) {
            Map<String, dynamic> userData =
                snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                const SizedBox(
                  height: 50,
                ),

                //profile pic
                Icon(
                  Icons.person,
                  size: 72,
                ),

                const SizedBox(
                  height: 10,
                ),

                //user email
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(
                  height: 50,
                ),

                //user details
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    "My Details",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                //username
                MyTextBox(
                  text: userData['username'],
                  sectionName: "username",
                  onTap: () => editField("username"),
                ),

                //bio
                MyTextBox(
                  text: userData['bio'],
                  sectionName: "bio",
                  onTap: () => editField("bio"),
                ),

                const SizedBox(
                  height: 50,
                ),

                //user posts
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    "My Posts",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
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
        },
      ),
    );
  }
}
