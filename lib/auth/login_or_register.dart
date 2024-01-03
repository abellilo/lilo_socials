import 'package:flutter/material.dart';
import 'package:lilo_socials/pages/login_page.dart';
import 'package:lilo_socials/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  _LoginOrRegisterState createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initialize show login page
  bool showLoginPage = true;

  //toggle between pages
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(onTap: togglePages,);
    }
    else{
      return RegisterPage(onTap: togglePages);
    }
  }
}
