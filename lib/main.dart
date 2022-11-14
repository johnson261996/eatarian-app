import 'package:eatarian_app/widget/home_widget.dart';
import 'package:eatarian_app/widget/login_widget.dart';
import 'package:eatarian_app/widget/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences  prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  await Firebase.initializeApp();
  runApp( MyApp(email:email));
}

class MyApp extends StatelessWidget {
  String? email;
   MyApp({required this.email});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  Wrapper(email:email),
      routes: <String, WidgetBuilder>{
        //'/otpScreen': (BuildContext ctx) => OtpScreen(),
        '/homeScreen': (BuildContext ctx) => HomeScreen(),
      },
    );
  }
}


