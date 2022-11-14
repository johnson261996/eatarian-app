import 'dart:async';

import 'package:eatarian_app/widget/home_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'country_picker.dart';

class PhoneWidget extends StatefulWidget {
  bool _isInit = true;
  var _contact = '';


  @override
  State<PhoneWidget> createState() => _PhoneWidgetState();
}

class _PhoneWidgetState extends State<PhoneWidget> {
  final _contactEditingController = TextEditingController();
  var _dialCode = '';
  late String phoneNo;
  late String smsOTP;
  late String verificationId;
  String errorMessage = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer _timer;
  bool showOtp = true;
  bool showLogin = false;
  //callback function of country picker
  void _callBackFunction(String name, String dialCode, String flag) {
    _dialCode = dialCode;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load data only once after screen load
    if (widget._isInit) {
     // widget._contact = '$_dialCode${_contactEditingController.text}';
     // generateOtp(widget._contact);
      widget._isInit = false;
    }
  }

  bool validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {

      showErrorDialog(context, 'Contact number can\'t be empty.');
      return false;
    }
    else if (!regExp.hasMatch(value)) {
      print('Please enter valid mobile number');

      showErrorDialog(context, 'Contact number is Invalid.');
      return false;
    }

    return true;
  }

  //Login click with contact number validation
/*  Future<void> clickOnLogin(BuildContext context) async {
    if (_contactEditingController.text.isEmpty) {
      showErrorDialog(context, 'Contact number can\'t be empty.');
    } else {
      final responseMessage ="$_dialCode${_contactEditingController.text}";
     // await Navigator.pushNamed(context, '/otpScreen', arguments: '$_dialCode${_contactEditingController.text}');
      if (responseMessage != null) {
        showErrorDialog(context, responseMessage as String);
      }
    }
  }*/

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


  //Method for generate otp from firebase
  Future<void> generateOtp(String contact) async {
    final PhoneCodeSent smsOTPSent = (String verId, [int? forceCodeResend]) {
      verificationId = verId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: contact,
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },
          codeSent: smsOTPSent,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
          },
          verificationFailed: (FirebaseAuthException  exception) {
            // Navigator.pop(context, exception.message);
          });
    } catch (e) {
      handleError(e as PlatformException);
      // Navigator.pop(context, (e as PlatformException).message);
    }
  }

  //Method for verify otp entered by user
  Future<void> verifyOtp(BuildContext c) async {
    if (smsOTP == null || smsOTP == '') {
      showAlertDialog(context, 'please enter 6 digit otp');
      return;
    }
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final UserCredential user = await _auth.signInWithCredential(credential);
      final User? currentUser = await _auth.currentUser;
      assert(user.user?.uid == currentUser?.uid);
     // Navigator.pushReplacementNamed(context, '/homeScreen');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (c) =>  HomeScreen(currentUser,null)),
      );
    } catch (e) {
      handleError(e as PlatformException);
    }
  }

  //Method for handle the errors
  void handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        showAlertDialog(context, 'Invalid Code');
        break;
      default:
        showAlertDialog(context, error.message);
        break;
    }
  }

  //Basic alert dialogue for alert errors and confirmations
  void showAlertDialog(BuildContext context, String? message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
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
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Column(children: [
      SizedBox(
        height: 40,
      ),
      Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          // ignore: prefer_const_literals_to_create_immutables
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CountryPicker(
              callBackFunction: _callBackFunction,
              headerText: 'Select Country',
              headerBackgroundColor: Theme.of(context).primaryColor,
              headerTextColor: Colors.white,
            ),
            SizedBox(
              width: _mediaQuery.width * 0.01,
            ),
            Expanded(
              child: TextField(
                decoration:  InputDecoration(
                  hintText: 'Contact Number',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 13.5),
                ),
                controller: _contactEditingController,
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
              ),
            ),
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
          widget._contact = '$_dialCode${_contactEditingController.text}';
          setState(() {
            result = validateMobile(_contactEditingController.text);
          });
          if(result){
            generateOtp(widget._contact);
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
            borderRadius: BorderRadius.circular(10),
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
            /*  onSubmitted: (text){
                smsOTP = text as String;
              },*/
              showCursor: true,
              onCompleted: (pin) {
                smsOTP = pin as String;
              },
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => verifyOtp(context),
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
      ],
    ]);
  }
}
