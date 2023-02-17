import 'package:chat_app/pages/About.dart';
import 'package:chat_app/pages/homePage.dart';
import 'package:chat_app/widgets/addPost.dart';
import 'package:chat_app/pages/signup.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class mainPage extends StatelessWidget {
  const mainPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),

      routes: {
        "/login": (context) => LoginPage(),
        "/signup" : (context) => SignUpPage(),
        "/homepage" : (context) => HomePage(),
        "/addpost" : (context) => AddPost(),
        "/about" : (context) => AboutPage(),
      },
    );
  }
}