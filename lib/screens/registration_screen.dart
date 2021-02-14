import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool submitValid = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool verify() {
    if (EmailAuth.validate(
        receiverMail: _emailController.value.text,
        userOTP: _otpController.value.text)) {
      return true;
    }
    return false;
  }

  ///a void funtion to send the OTP to the user
  void sendOtp() async {
    EmailAuth.sessionName = "Speed Chat";
    bool result =
        await EmailAuth.sendOtp(receiverMail: _emailController.value.text);
    if (result) {
      print('OTP sent');
      setState(() {
        submitValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'myLogo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    controller: _emailController,
                    onChanged: (value) {
                      //Do something with the user input.
                    },
                    decoration: kInputeDecoration.copyWith(
                      hintText: 'Enter your Email',
                      suffixIcon: TextButton(
                        onPressed: () {
                          sendOtp();
                        },
                        child: Text(
                          'Send OTP',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    controller: _passwordController,
                    onChanged: (value) {
                      //Do something with the user input.
                    },
                    decoration: kInputeDecoration.copyWith(
                        hintText: 'Enter your Password'),
                  ),
                  submitValid
                      ? TextField(
                          controller: _otpController,
                          onChanged: (value) {
                            //Do something with the user input.
                          },
                          decoration: kInputeDecoration.copyWith(
                              hintText: 'Enter your OTP'),
                        )
                      : Container(height: 1),
                  SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Material(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      elevation: 5.0,
                      child: MaterialButton(
                        onPressed: () async {
                          //Implement registration functionality.
                          try {
                            if (verify()) {
                              final signIn =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text);
                              if (signIn != null) {
                                await _firestore
                                    .collection('Users')
                                    .add({'email': _emailController.text});
                                Navigator.pushReplacementNamed(
                                    context, '/registrationScreen');
                              }
                            } else {
                              print('email not verify');
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        minWidth: 200.0,
                        height: 42.0,
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
