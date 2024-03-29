import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lilo_socials/auth/auth_service/auth_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool loading = true;

  void registerUser() async {
    try {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty) {
        if(passwordController.text == confirmPasswordController.text){
          setState(() {
            loading = false;
          });
          //auth service instance
          final authService = AuthService();
          await authService.registerUser(
              emailController.text, passwordController.text);
          setState(() {
            loading = true;
          });
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password don't match"))
          );
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fill all fields"))
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code)));
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
                    "Let's create an account for you",
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
                    height: 10,
                  ),

                  //password textfield
                  MyTextField(
                      controller: confirmPasswordController,
                      textHint: "Confirm Password",
                      obsureText: true),

                  const SizedBox(
                    height: 25,
                  ),

                  //signup
                  MyButton(text: "Sign Up", onTap: registerUser),

                  const SizedBox(
                    height: 25,
                  ),

                  //go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Sign In now",
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
