

import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class EmailWidget extends StatefulWidget {
  const EmailWidget({Key? key}) : super(key: key);

  @override
  State<EmailWidget> createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {

  late EmailAuth emailAuth;
  TextEditingController _emailcontroller = TextEditingController();
  late String emailOTP;
  bool submitValid = false;
  bool showOtp = true;
  bool showLogin = false;

  @override
  void initState() {
    emailAuth = EmailAuth(sessionName: "Eatarian app");
 /*   var remoteServerConfig = {"server" : "serverUrl", "serverKey" : "serverKey"};
    emailAuth.config(remoteServerConfig);*/
  }

  bool validateEmail(String value) {
    RegExp regExp =  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (value.length == 0) {

      showErrorDialog(context, 'Email address can\'t be empty.');
      return false;
    }
    else if (!regExp.hasMatch(value)) {
      print('Please enter valid Email address');

      showErrorDialog(context, 'Email address is Invalid.');
      return false;
    }

    return true;
  }

  //Alert dialogue to show error and response
  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final AlertDialog alert = AlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  void verify() {
    bool result= emailAuth.validateOtp(
        recipientMail: _emailcontroller.value.text,
        userOtp: emailOTP);
    if(result){
      Navigator.pushReplacementNamed(context, '/homeScreen');
    }else{
      print("email auth:$result");
    }
  }

  /// a void funtion to send the OTP to the user
  /// Can also be converted into a Boolean function and render accordingly for providers
  void sendOtp() async {
    try{
      bool result = await emailAuth.sendOtp(
          recipientMail: _emailcontroller.value.text, otpLength: 6);
      if (result) {
        setState(() {
          submitValid = true;
        });
      }
    }catch(e){
      print('Exception:$e');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children:[
        SizedBox(
          height: 40,
        ),
        Container(
          height: 55,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),

              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailcontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Email ID",
                    ),
                  ))
            ],
          ),
        ),
        SizedBox(
          height: 40,
        ),
        if(showOtp)
        GestureDetector(
          onTap: () {
            bool result=false;
            setState(() {
              result = validateEmail(_emailcontroller.text);
            });
            if(result){
              sendOtp();
              setState(() {
                showLogin = true;
                showOtp = false;
              });
            }
            },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 253, 188, 51),
              borderRadius: BorderRadius.circular(36),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Send OTP',
              style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
          if(showLogin)...[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter OTP",style:TextStyle(
                fontSize: 16,fontWeight: FontWeight.bold
            ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "We have sent the code verification to your phone number",
              style: TextStyle(
                  fontSize: 12,color: Colors.grey
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Pinput(
              length: 6,
              // defaultPinTheme: defaultPinTheme,
              // focusedPinTheme: focusedPinTheme,
              // submittedPinTheme: submittedPinTheme,

              showCursor: true,
              onCompleted: (pin) => emailOTP = pin as String,
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {verify();},
              child: Container(
                margin: const EdgeInsets.all(8),
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 253, 188, 51),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.black, fontSize: 16.0,fontWeight: FontWeight.bold),
                ),
              ),
            ),

          ],
        ),
        Text(
          "By clicking login,you accept our",
          style: TextStyle(
              fontSize: 15,color: Colors.black,fontWeight:FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
        Text('Terms and Condtions',  style: TextStyle(
            fontSize: 15,color: Colors.blue
        ),
          textAlign: TextAlign.center,)
      ]
     ]
    );
  }
}
