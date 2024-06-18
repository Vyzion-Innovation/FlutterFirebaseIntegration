import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauthsigninsignup/custom_functions/custom_button.dart';
import 'package:firebaseauthsigninsignup/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool showSpinner = false;
  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                  ),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      onTapResetPassword();
                    }
                  },
                  text: 'Reset',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onTapResetPassword() async {
    setState(() {
      showSpinner = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
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
    ),
  );
}
