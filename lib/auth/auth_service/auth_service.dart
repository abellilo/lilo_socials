import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  //fibase auth instance
  final firebaseAuth = FirebaseAuth.instance;

  //register user
  Future registerUser(String email, String password) async {
    await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  //sign user
  Future signIn(String email, String password) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  //sign out
  Future signOut() async{
    await firebaseAuth.signOut();
  }
}
