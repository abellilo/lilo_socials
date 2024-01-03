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
          onPressed: ()=> Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),

          //profile pic
          Icon(Icons.person, size: 72,),

          const SizedBox(height: 10,),

          //user email
          Text(currentUser.email!,textAlign: TextAlign.center,style: TextStyle(
            color: Colors.grey[700]
          ),),

          const SizedBox(height: 50,),

          //user details
          Padding(padding: EdgeInsets.only(left: 25),
          child: Text("My Details",style: TextStyle(
            color: Colors.grey[600]
          ),),),

          //username
          MyTextBox(text: "Abel Ayinde", sectionName: "username", onTap: (){},),

          //bio

          //user posts

        ],
      ),
    );
  }
}
