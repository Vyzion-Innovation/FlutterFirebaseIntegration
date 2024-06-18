import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauthsigninsignup/custom_functions/custom_button.dart';
import 'package:firebaseauthsigninsignup/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

final _auth = FirebaseAuth.instance;

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }

                        return null;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email',
                      )),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }

                        return null;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your password.')),
                  Container(
                    padding: const EdgeInsets.fromLTRB(180, 0, 0, 0),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgetPassword()),
                          );
                        },
                        child: const Text('Forgot Password')),
                  ),
                  CustomButton(
                      text: 'Sign In',
                      onPressed: () {
                        onTapSignIn();
                      })
                ],
              ),
            ),
          ),
        ));
  }

  onTapSignIn() async {
    setState(() {
      showSpinner = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        final newUser = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (newUser.user != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userdata', newUser.toString());
          if (!mounted) return;
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return e.code;
        } else if (e.code == 'wrong-password') {
          return e.code;
        }
        debugPrint(e.toString()) ;
      }
    }
    setState(() {
      showSpinner = false;
    });
  }

  InputDecoration kTextFieldDecoration = const InputDecoration(
      hintText: 'Enter a value',
      hintStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ));
}
