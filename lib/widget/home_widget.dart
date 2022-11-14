
import 'package:eatarian_app/widget/login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  User? user;
  String? email;
   HomeScreen([ this.user,  this.email,]) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('email');
              await FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      const LoginWidget()),(route) => false));
              },
          ),
          // add more IconButton
        ],
      ),
      body: Center(
        child: Container(
            child:Text("Welcome home\n\n${user.toString()}\n${email.toString()}",  textAlign: TextAlign.center,)
            ),
      ),
    );
  }
}
