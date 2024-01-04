import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  //fibase auth instance
  final firebaseAuth = FirebaseAuth.instance;

  //create user
  Future registerUser(String email, String password) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    //after creating a user lets create a new document in the firebase and call is Users
    FirebaseFirestore.instance
        .collection("Users")
        .doc(userCredential.user!.email!)
        .set({
      'username': email.split("@")[0], //initial username,
      'bio' : 'Empty bio...' //initially empty bio
      //
    });
  }

  //sign user
  Future signIn(String email, String password) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  //sign out
  Future signOut() async {
    await firebaseAuth.signOut();
  }
}
