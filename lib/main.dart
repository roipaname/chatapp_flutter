import 'package:chatapp_firebase/screen/home_page.dart';
import 'package:chatapp_firebase/shared/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:chatapp_firebase/auth/login.dart';

import 'helper/helper_function.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        // ignore: prefer_const_constructors
        options: FirebaseOptions(
      apiKey: Constants.apiKey,
      // authDomain: "chatappflutter-1a83a.firebaseapp.com",
      projectId: Constants.projectId,
      //storageBucket: "chatappflutter-1a83a.appspot.com",
      messagingSenderId: Constants.messagingSenderId,
      appId: Constants.appId,
    ));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    bool _isSignedIn = false;

    getUserLoggedInStatus() async {
      await HelperFunctions.getUserLoggedInStatus().then((value) {
        if (value != null) {
          setState(() {
            _isSignedIn = value;
          });
        }
      });
    }

    @override
    // ignore: unused_element
    void initState() {
      super.initState();
      getUserLoggedInStatus();
    }

    return MaterialApp(
      theme: ThemeData(
          primaryColor: Constants.primaryColor,
          scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ? HomePage() : Loginpage(),
    );
  }
}
