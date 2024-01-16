import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lilo_socials/auth/auth_service/auth_service.dart';
import 'package:lilo_socials/components/my_button.dart';
import 'package:lilo_socials/components/my_textfield.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = true;

  Future<void> signIn() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        loading = false;
      });
      try {
        //auth service instance
        final authService = AuthService();
        //call sign in metthod
        await authService.signIn(emailController.text, passwordController.text);
        setState(() {
          loading = true;
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          loading = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.code))
        );
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fill all fields"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[300],
      body: loading ? SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  Image.asset("lib/assets/logo.png", width: MediaQuery
                      .of(context)
                      .size
                      .width / 3,),

                  const SizedBox(
                    height: 50,
                  ),

                  //welcome back
                  Text(
                    "Welcome back you've been missed",
                    style: TextStyle(color: Colors.white),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  //email textfield
                  MyTextField(
                      controller: emailController,
                      textHint: "Email",
                      obsureText: false),

                  const SizedBox(
                    height: 10,
                  ),

                  //password textfield
                  MyTextField(
                      controller: passwordController,
                      textHint: "Password",
                      obsureText: true),

                  const SizedBox(
                    height: 25,
                  ),

                  //signin
                  MyButton(text: "Sign In", onTap: signIn),

                  const SizedBox(
                    height: 25,
                  ),

                  //go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member?",
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )
          : Center(
        child: SpinKitChasingDots(
          size: 150,
          color: Colors.white,
        ),
      ),
    );
  }
}
