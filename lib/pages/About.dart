import 'package:chat_app/Colors/myColors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutPage extends StatelessWidget {

  var styleFont = const TextStyle(fontSize: 18);
  var _url = Uri.parse('https://github.com/Evilking009');

  launchLink() async{
    if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        centerTitle: true,
        flexibleSpace: Container(decoration: BoxDecoration(gradient: navyblue_gradient)),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            CircleAvatar(
              backgroundImage: AssetImage('assets/about.png'),
              radius: 100,
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Made with ', style: styleFont),
                Icon(Icons.favorite, color: Colors.pink),
                Text(' in Firebase and Flutter', style: styleFont)
              ],
            ),

            Text("Liked My App?", style: styleFont),
            InkWell(
              onTap: () => launchLink(),
              child: Text("Follow Me! ", style: TextStyle(fontSize: 18, color: primary_color))),




          ],
        ),
      ),
    );
  }
}