import 'dart:io';
import 'package:chat_app/model/Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:chat_app/colors/myColors.dart';


class EditPost extends StatelessWidget {
  EditPost({ Key? key, required this.user }) : super(key: key);

    editModel user;

    final FirebaseFirestore db = FirebaseFirestore.instance;
    final FirebaseStorage storage = FirebaseStorage.instance;

    String image_path = "";
    String image_name = "";

    late TextEditingController _titleController = TextEditingController(text: user.title);
    late TextEditingController _descriptionController = TextEditingController(text: user.description);
    

  @override
  Widget build(BuildContext context) {

    pickMyImage() async{

      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      image_path = image!.path;
      image_name = path.basename(image.path);

    }

    updatePost() async{
      try{

      String title = _titleController.text;
      String description = _descriptionController.text;
      String url = "";

      if(image_path != ""){
      Reference ref = FirebaseStorage.instance.ref("/$image_name");
      File ff = File(image_path);
      await ref.putFile(ff);
      url = await ref.getDownloadURL();
      }

      db.collection("UserPosts").doc(user.docID).update({
        "title": title,
        "description": description,
        "url": url,
      });

      _titleController.clear();
      _descriptionController.clear();

      SnackBar SS = SnackBar(content: Text("Post Updated Successfully"), backgroundColor: Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(SS);

      Navigator.pop(context);


      }  catch(e){

      SnackBar SS = SnackBar(content: Text(e.toString()), backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(SS);

      }

    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Post"),
        centerTitle: true,
        flexibleSpace: Container(decoration: BoxDecoration(gradient: navyblue_gradient)),
      ),


      body: ListView(
        padding: EdgeInsets.all(30),
        children: [

          SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                color: textField_shade,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: secondary_color),
                  labelText: "Title",
                  labelStyle: TextStyle(color: primary_color),
                  prefixIcon: Icon(Icons.title, color: primary_color),
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

            SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                color: textField_shade,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: secondary_color),
                  labelText: "Description",
                  labelStyle: TextStyle(color: primary_color),
                  prefixIcon: Icon(Icons.description, color: primary_color),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: secondary_color, width: 2.0),
                  ),
                  border: InputBorder.none,
                ),
                enableSuggestions: true,
                maxLines: 3,
              ),
            ),

            SizedBox(height: 30),

           Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ElevatedButton(
                child: Text("Edit Image"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primary_color),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)))
                  ),
                onPressed: ()=>pickMyImage(),
                ),
            ),

            SizedBox(height: 20),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ElevatedButton(
                child: Text("Update"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primary_color),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)))
                  ),
                onPressed: ()=>updatePost(),
                ),
            ),

        ],
      ),
    );
  }
}