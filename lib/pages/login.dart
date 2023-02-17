import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/colors/myColors.dart';
import 'package:chat_app/model/Model.dart';

class LoginPage extends StatefulWidget {

  var password_eye = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  @override
  Widget build(BuildContext context) {

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;


    loginMethod() async{

      String email = widget._emailController.text;
      String password = widget._passwordController.text;

      try{

      final UserCredential user = await auth.signInWithEmailAndPassword(email: email, password: password);
      var data = await db.collection('Users').doc(user.user!.uid).get();
      userModel users = userModel(email: data['email'], username: data['username']);
      Navigator.pushNamed(context, '/homepage', arguments: users);


       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successfully"), backgroundColor: Colors.green));

      } on FirebaseException catch (e) {
        // print(e.message);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString()), backgroundColor: Colors.red,));
      }

    }

    signupMethod() => Navigator.pushNamed(context, '/signup');

    return Scaffold(

      body: ListView(
        padding: EdgeInsets.zero,
        children: [

          // TOP TEXT
          Container(
            height: 200,
            decoration: BoxDecoration(
              // color: primary_color,
              gradient: navyblue_gradient
            ),
            child: Center(child: Text("Cool Blue Chat",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold
              ))),
          ),

          SizedBox(height: 90),

          // TEXT FIELDS
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [

                Container(
              decoration: BoxDecoration(
                color: textField_shade,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: widget._emailController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: primary_color),
                  labelText: "Email",
                  labelStyle: TextStyle(color: primary_color),
                  prefixIcon: Icon(Icons.email_outlined, color: primary_color),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: secondary_color, width: 2.0),
                  ),
                  border: InputBorder.none,
                ),
                enableSuggestions: true,
                keyboardType: TextInputType.emailAddress,
              ),
            ),

            SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: textField_shade,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: widget._passwordController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: primary_color),
                  labelText: "Password",
                  labelStyle: TextStyle(color: primary_color),
                  prefixIcon: Icon(Icons.lock_outline, color: primary_color),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: secondary_color, width: 2.0),
                  ),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(widget.password_eye ? Icons.visibility_off : Icons.visibility),
                    color: (widget.password_eye? Colors.grey : primary_color),
                    splashRadius: 20,
                    onPressed: (){
                      setState(() {
                        widget.password_eye = !widget.password_eye;
                      });
                      
                    },
                  ),
                ),
                obscureText: widget.password_eye,
                keyboardType: TextInputType.visiblePassword,
              ),
            ),

            SizedBox(height: 30),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ElevatedButton(
                child: Text("Login"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primary_color),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                  ),
                onPressed: ()=>loginMethod(),
                ),
            ),

            SizedBox(height: 15),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ElevatedButton(
                child: Text("Sign Up", style: TextStyle(color: primary_color)),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(2),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    side: BorderSide(color: secondary_color, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    ),)
                  ),
                onPressed: ()=>signupMethod(),
                ),
            ),
              ],
            ),
          ),
          
        ],
      ),

    );
  }
}