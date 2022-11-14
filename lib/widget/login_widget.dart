import 'package:eatarian_app/widget/email_widget.dart';
import 'package:eatarian_app/widget/phone_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      initialIndex: tabIndex,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
          ),
          elevation: 0,
        ),
        body: Container(
            margin: EdgeInsets.only(left: 25, right: 25),
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Please Enter your phone or email",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 50,
                  child: AppBar(
                    elevation: 0.3,
                    backgroundColor: Colors.white,
                    bottom: const TabBar(
                      labelColor: Colors.black,
                      //indicatorColor: Color(0xffFFE90C),
                      indicator: UnderlineTabIndicator(
                        borderSide:
                            BorderSide(width: 5.0, color: Color(0xffFFE90C)),
                      ),
                      tabs: [
                        Tab(
                          text: "Phone Number ",
                        ),
                        Tab(
                          text: "Email",
                        ),
                      ],
                    ),
                  ),
                ),
                 SizedBox(
                  height: 500,
                  child: TabBarView(children: [
                    // first tab bar view widget
                    PhoneWidget(),

                    EmailWidget(),
                  ]),
                )
              ],
            ))),
      ),
    );
  }
}
