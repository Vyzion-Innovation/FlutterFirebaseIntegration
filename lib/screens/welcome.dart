import 'package:firebaseauthsigninsignup/custom_functions/custom_button.dart';
import 'package:firebaseauthsigninsignup/screens/register_screen.dart';
import 'package:firebaseauthsigninsignup/screens/signin_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CustomButton(
                  text: 'Register User',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistrationScreen()),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  text: 'Sign In User',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    );
                  },
                ),
              ]),
        ));
  }
}
