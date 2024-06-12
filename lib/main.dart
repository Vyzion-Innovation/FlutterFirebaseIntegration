import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseauthsigninsignup/firebase_options.dart';
import 'package:firebaseauthsigninsignup/screens/createtasks.dart';
import 'package:firebaseauthsigninsignup/screens/homescreen.dart';
import 'package:firebaseauthsigninsignup/screens/signinscreen.dart';
import 'package:firebaseauthsigninsignup/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<bool> autoLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userdata') != null ? true : false;
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var isLogin = await autoLogin();

  runApp(isLogin ? MyApp2() : MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
     initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) =>  WelcomeScreen(),
    // When navigating to the "/second" route, build the SecondScreen widget.
    '/second': (context) =>  LoginScreen(),
    '/home': (context) =>  HomeScreen(),
    '/todopage': (context) =>  ToDoPage(),
  },

     
    );
  }
}
class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
     initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) =>  HomeScreen(),
    // When navigating to the "/second" route, build the SecondScreen widget.
    '/second': (context) =>  LoginScreen(),
    '/home': (context) =>  HomeScreen(),
    '/todopage': (context) =>  ToDoPage(),
  },

     
    );
  }
}


