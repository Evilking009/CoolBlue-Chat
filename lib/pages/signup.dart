import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/colors/myColors.dart';

class SignUpPage extends StatelessWidget {

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController usernameController = TextEditingController();

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    showSnackBar(String textName, var colorName) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(textName), backgroundColor: colorName));

    signUpMethod() async{
      try{

        String email = emailController.text;
        String username = usernameController.text;
        String password = passwordController.text;
        var userID = await auth.createUserWithEmailAndPassword(email: email, password: password);

        await db.collection('Users').doc(userID.user!.uid).set({
          'username': username,
          'email' : email,
        });

        showSnackBar("REGISTRATION SUCCESSFULLY!", Colors.green);

        Navigator.pushNamed(context, '/login');



      } on FirebaseException catch (e){
        showSnackBar(e.message.toString(), Colors.red);  
      }
    }

    return Scaffold(

      body: ListView(
        padding: EdgeInsets.zero,
        children: [

          // TOP TEXT
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: navyblue_gradient
            ),
            child: Center(child: Text("Sign Up",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold
              ))),
          ),

          SizedBox(height: 20),

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
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: primary_color),
                  labelText: "Username",
                  labelStyle: TextStyle(color: primary_color),
                  prefixIcon: Icon(Icons.person_2_outlined, color: primary_color),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: secondary_color, width: 2.0),
                  ),
                  border: InputBorder.none,
                ),
                controller: usernameController,
              ),
            ),

            SizedBox(height: 50),

                Container(
              decoration: BoxDecoration(
                color: textField_shade,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
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
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
            ),

            SizedBox(height: 50),

            Container(
              decoration: BoxDecoration(
                color: textField_shade,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
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
                ),
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
              ),
            ),

            SizedBox(height: 50),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ElevatedButton(
                child: Text("Signup"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primary_color),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                  ),
                onPressed: ()=>signUpMethod(),
                ),
            ),

            SizedBox(height: 15),


              ],
            ),
          ),
           
        ],
      ),

    );
  }
}