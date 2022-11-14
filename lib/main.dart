import 'package:eatarian_app/widget/home_widget.dart';
import 'package:eatarian_app/widget/login_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginWidget(),
      routes: <String, WidgetBuilder>{
        //'/otpScreen': (BuildContext ctx) => OtpScreen(),
        '/homeScreen': (BuildContext ctx) => HomeScreen(),
      },
    );
  }
}


