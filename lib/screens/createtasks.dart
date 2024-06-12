import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseauthsigninsignup/functions/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  File? _image;
  ImagePicker? picker;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var outputFormat = DateFormat('dd-MMMM-yyyy');
        var outputDate = outputFormat.format(picked);
        _dateController.text =
            outputDate; // Update _dateController with selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                                File? image =
                                    await ImageHelper.getImageFromGallery();
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Title'),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 234, 234),
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date'),
                    TextFormField(
                      onTap: () {
                        _selectDate(context);
                      },
                      controller: _dateController,
                      decoration: const InputDecoration(
                        hintText: 'Select date',
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 234, 234),
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Description'),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 234, 234),
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Add category'),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 234, 234),
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                SizedBox(
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        uploadFile(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 29, 39, 179),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      textStyle: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    child: const Text(
                      'Create a new task',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  User? userData() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    return user;
  }

  void _createTask(BuildContext context) async {
    User? user = userData();

    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(selectedDate);

    await FirebaseFirestore.instance.collection('tasks').add({
      'title': _titleController.text,
      'date': outputDate,
      'description': _descriptionController.text,
      'category': _categoryController.text,
      'id': user?.uid,
      'imageurl': imageUrl
    });
    Navigator.pop(context);
  }

  Future uploadFile(BuildContext context) async {
    if (_image != null) {
      final fileName = basename(_image!.path);
      final destination = 'files/$fileName';

      try {
        final _storage = FirebaseStorage.instance;
        final ref = _storage.ref(destination);

        UploadTask uploadTask = ref.putFile(_image!);
        imageUrl = await (await uploadTask).ref.getDownloadURL();
        _createTask(context);
      } catch (e) {
        print('error occured');
      }
    } else {
      _createTask(context);
    }
  }
}
