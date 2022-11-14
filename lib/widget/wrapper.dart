import 'package:eatarian_app/widget/home_widget.dart';
import 'package:eatarian_app/widget/login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Wrapper extends StatefulWidget {
  String? email;
   Wrapper({required this.email});

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User? user;

  @override
  void didChangeDependencies() async{


    print("email:${widget.email}");
    print("didChangeDependencies");

  }

  @override
  void initState() {
    super.initState();
    //Listen to Auth State changes
    print("initState");
    FirebaseAuth.instance
        .authStateChanges()
        .listen((event) => updateUserState(event));
  }
  //Updates state when user state changes in the app
  updateUserState(event) {
    setState(() {
      user = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build');

    print('user:$user');
    if (user != null || widget.email !=null )
      return HomeScreen(user,widget.email);
    else
      return LoginWidget();
  }


}