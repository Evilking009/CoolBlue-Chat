import 'package:chat_app/widgets/editPost.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/colors/myColors.dart';
import 'package:chat_app/model/Model.dart';

class HomePage extends StatelessWidget {
  HomePage({ Key? key}) : super(key: key);

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final Stream users_stream = FirebaseFirestore.instance.collection("Users").snapshots();
  final Stream posts_stream = FirebaseFirestore.instance.collection("UserPosts").snapshots();

  @override
  Widget build(BuildContext context) {

    userModel data = ModalRoute.of(context)!.settings.arguments as userModel; // call by data.username
    addPost() => Navigator.pushNamed(context, "/addpost", arguments: data);
    aboutPage() => Navigator.pushNamed(context, "/about");

    editPost(String docID, String title, String description){
      editModel user = editModel(docID: docID, title: title, description: description);
      Navigator.push(context, MaterialPageRoute(builder: (context) => EditPost(user: user)));
      }

    deletePost(String document_id){
      try{
        showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text("Are You Sure?"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              TextButton(onPressed: () async{

                await db.collection("UserPosts").doc(document_id).delete();
                Navigator.pop(context);


              }, child: Text("Yes")),
              TextButton(onPressed: ()=> Navigator.pop(context), child: Text("No"))
            ]),
          );
        });


      } on FirebaseException catch (e){
        print(e.message);
      }
    }
  
    return DefaultTabController(
      length: 2,
      child: Scaffold(

      appBar: AppBar(
        title: Text("Welcome ${data.username}"),
        backgroundColor: primary_color,
        flexibleSpace: Container(decoration: BoxDecoration(gradient: navyblue_gradient)),
        bottom: TabBar(
          indicatorWeight: 3,
          tabs: [
          Tab(text: "Users"),
          Tab(text: "Posts"),
        ]),
      ),

      body: TabBarView(children: [

        // USERS LIST
        StreamBuilder(
          stream: users_stream,
          builder: (context, AsyncSnapshot snapshot){

            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data.size,
                itemBuilder: (context, index){

                  var username = snapshot.data.docs[index]['username'];
                  var email = snapshot.data.docs[index]['email'];

                return ListTile(
                leading: CircleAvatar(child: Icon(Icons.person), backgroundColor: primary_color),
                title: Text(username),
                subtitle: Text(email),
                trailing: Icon(Icons.verified, color: username == data.username ? Colors.green : Colors.grey),
                 );


                });
            }

            else return Center(child: CircularProgressIndicator());

          }),


          // USER ALL POSTS
          StreamBuilder(
            stream: posts_stream,
            builder: (context, AsyncSnapshot snapshot){

              if(snapshot.hasData){
                return ListView.builder(
                  reverse: true,
                itemCount: snapshot.data.size,
                itemBuilder: (context, index){

                  String username = snapshot.data.docs[index]['username'];
                  String email = snapshot.data.docs[index]['email'];
                  String title = snapshot.data.docs[index]['title'];
                  String description = snapshot.data.docs[index]['description'];
                  String url = snapshot.data.docs[index]['url'];
                  String docID = snapshot.data.docs[index].id;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                        borderRadius: BorderRadius.circular(5),

                      ),
                      child: Column(
                        children: [
                          ListTile(
                          leading: CircleAvatar(child: Icon(Icons.person), backgroundColor: username == data.username ? Colors.green : primary_color),
                          title: Text(username),
                          subtitle: Text(email),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              if(data.username == username) IconButton(onPressed: ()=>editPost(docID, title, description), icon: Icon(Icons.edit_rounded)),
                              if(data.username == username) IconButton(onPressed: ()=>deletePost(docID), icon: Icon(Icons.cancel)),
                              
                            ],
                          ),
                          ),

                          Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Divider(color: Colors.black),
                                Text(description),
                              ],
                            ),
                          ),

                          url != "" ?
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.network(url,fit: BoxFit.cover),
                          ): Container()

                        ],
                      ),
                    ),
                  );
                });
        }
              else return Center(child: CircularProgressIndicator());
      }),

      ]),

      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/header.webp'))
              ),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Text(data.username, style: TextStyle(color: Colors.white)),
                  subtitle: Text(data.email, style: TextStyle(color: Colors.white)),
                  trailing: CircleAvatar(child: Icon(Icons.person_2), radius: 35),
                ),
              )
              ),


              ListTile(
                title: Text("About"),
                leading: Icon(Icons.info),
                onTap: () => aboutPage(),
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()=>addPost(),
        label: Text("Add Post"),
        icon: Icon(Icons.add),
        backgroundColor: primary_color,
      ),

    ));
  }
}