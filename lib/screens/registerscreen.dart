import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseauthsigninsignup/functions/image_helper.dart';
import 'package:firebaseauthsigninsignup/screens/signinscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart';
//code for designing the UI of our text field where the user writes his email id or password

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  File? _image;
  ImagePicker? picker;
  final _auth = FirebaseAuth.instance;
  String? imageUrl;
  String? email;
  String? password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          children: [
            SizedBox(
              height: 198,
              width: 198,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 100,
                    child: ClipOval(
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              height: 200,
                              width: 200,
                            )
                          : Image.network(
                              'https://picsum.photos/200'), // Use Image.asset for local assets
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(136, 144, 0, 0),
                    child: Container(
                      height: 62,
                      width: 62,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF13326E),
                      ),
                      child: SizedBox(
                        height: 37.2,
                        width: 37.2,
                        child: IconButton(
                            color: Colors.white,
                            onPressed: () async {
                              File? image = await ImageHelper.getImageFromGallery();
                              if (image != null) {
                                setState(() {
                                  _image = image;
                                });
                              }
                            },
                            icon: const Icon(Icons.camera_alt_outlined),
                          ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your email')),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                        //Do something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your Password')),
                  SizedBox(
                    height: 24.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email!, password: password!);
                        if (newUser != null) {
                          await uploadFile();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        }
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    },
                    child: Text('SIgnUp'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> uploadImage() async {
  //   if (_image != null) {
  //     try {
  //       final _storage = FirebaseStorage.instance;

  //       var imageName = DateTime.now().millisecondsSinceEpoch.toString();
  //       Reference ref = _storage.ref().child('driver_images/$imageName.jpg');
  //       UploadTask uploadTask = ref.putData(_image!.readAsBytesSync(),  SettableMetadata(contentType: 'image/png'));
  //       imageUrl = await (await uploadTask).ref.getDownloadURL();
  //       saveUserData();
  //     } catch (e) {
  //       print('Error uploading image: $e');
  //     }
  //   }
  // }
  Future uploadFile() async {
    if (_image == null) return;
    final fileName = basename(_image!.path);
    final destination = 'files/$fileName';

    try {
      final _storage = FirebaseStorage.instance;
      final ref = _storage.ref(destination);
       
        UploadTask uploadTask = ref.putFile(_image!);
        imageUrl = await (await uploadTask).ref.getDownloadURL();
      saveUserData();
    } catch (e) {
      print('error occured');
    }
  }

  Future<void> saveUserData() async {
    try {
      final _firestore = FirebaseFirestore.instance;
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .set({'photoURL': imageUrl, 'uid': _auth.currentUser?.uid});
    } catch (e) {
      print('Error saving user data: $e');
    }
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
