import 'package:flutter/material.dart';
import 'package:speedchat/screens/chat_screen.dart';
import 'package:speedchat/screens/login_screen.dart';
import 'package:speedchat/screens/registration_screen.dart';
import 'package:speedchat/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => WelcomeScreen(),
          '/chatScreen': (context) => ChatScreen(),
          '/registrationScreen': (context) => RegistrationScreen(),
          '/loginScreen': (context) => LoginScreen()
        });
  }
}
