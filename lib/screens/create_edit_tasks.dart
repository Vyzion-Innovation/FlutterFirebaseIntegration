import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseauthsigninsignup/custom_functions/custom_button.dart';
import 'package:firebaseauthsigninsignup/custom_functions/custom_textfield.dart';
import 'package:firebaseauthsigninsignup/custom_functions/image_helper.dart';
import 'package:firebaseauthsigninsignup/utilities/task_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart';

class ToDoPage extends StatefulWidget {
  final TaskModel? task;

  const ToDoPage({super.key, this.task});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String dropdownvalue = 'Item 1';
  bool showSpinner = false;

  DateTime selectedDate = DateTime.now();
  File? _image;
  ImagePicker? picker;
  String? imageUrl;
  List<String> retrievedcategoryList = [];

  @override
  void initState() {
    super.initState();
    _initRetrieval();

    if (widget.task != null) {
      _titleController.text = widget.task!.title ?? '';
      _descriptionController.text = widget.task!.description;
      _dateController.text = widget.task!.date;
      imageUrl = widget.task!.imageurl;
    }
  }

  Future<void> _initRetrieval() async {
    var cList = await fetchCategory();
    setState(() {
      retrievedcategoryList = cList;

      dropdownvalue = retrievedcategoryList.first;
    });
  }

  Future<List<String>> fetchCategory() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection("categoryList").get();
    return snapshot.docs.map((doc) => doc['category'] as String).toList();
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
        _dateController.text = outputDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
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
                            child: imageUrl != null
                                ? Image.network(
                                    imageUrl!,
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: 200,
                                  )
                                : _image != null
                                    ? Image.file(
                                        _image!,
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: 200,
                                      )
                                    : Image.asset(
                                        'assets/noimage.png',
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: 200,
                                      ),
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
                                      imageUrl = null;
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
                  CustomTextField(
                    controller: _titleController,
                    label: 'Title',
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text('Date'),
                      ),
                      GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                hintText: 'Select date',
                                // enabled: false,
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 234, 234),
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a date';
                                }
                                return null;
                              },
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Description',
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text('Category'),
                      ),
                      DropdownButtonFormField<String>(
                        value: dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 239, 234, 234),
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                        items: retrievedcategoryList.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        uploadFile(() {
                          if (!mounted) return;
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    text: widget.task == null
                        ? 'Create a new task'
                        : 'Update task',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  User? userData() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return user;
  }

  void _createTask(VoidCallback onSuccess) async {
    User? user = userData();

    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(selectedDate);

    await FirebaseFirestore.instance.collection('tasks').add({
      'title': _titleController.text,
      'date': outputDate,
      'description': _descriptionController.text,
      'category': dropdownvalue,
      'id': user?.uid,
      'imageurl': imageUrl
    });

    setState(() {
      showSpinner = false;
    });

    onSuccess.call();
  }

  Future uploadFile(VoidCallback onSuccess) async {
    setState(() {
      showSpinner = true;
    });

    if (_image != null) {
      final fileName = basename(_image!.path);
      final destination = 'files/$fileName';

      try {
        final storage = FirebaseStorage.instance;
        final ref = storage.ref(destination);

        UploadTask uploadTask = ref.putFile(_image!);
        imageUrl = await (await uploadTask).ref.getDownloadURL();

        if (widget.task == null) {
          _createTask(onSuccess);
        } else {
          _updateTask(onSuccess);
        }
      } catch (e) {
        print('error occurred');
        onSuccess.call();
      }
    } else {
      _createTask(onSuccess);
    }
  }

  Future<void> _updateTask(VoidCallback onSuccess) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(selectedDate);

    await db.collection('tasks').doc(widget.task!.taskId).update({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'category': dropdownvalue,
      'date': outputDate,
      'imageurl': imageUrl,
    });

    setState(() {
      showSpinner = false;
    });

    onSuccess.call();
  }
}
