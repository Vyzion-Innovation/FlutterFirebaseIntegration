import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauthsigninsignup/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditToDoPage extends StatefulWidget {
  final TaskModel task;
  EditToDoPage({required this.task});

  @override
  State<EditToDoPage> createState() => _EditToDoPageState();
}

class _EditToDoPageState extends State<EditToDoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    print(widget.task.user_id);
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
        child: Column(
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateTask,
                  child: Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // void _createTask(BuildContext context) async {
  //   User? user = userData();

  //   var outputFormat = DateFormat('yyyy-MM-dd');
  //   var outputDate = outputFormat.format(selectedDate);

  //   await FirebaseFirestore.instance.collection('tasks').add({
  //     'title': _titleController.text,
  //     'date': outputDate,
  //     'description': _descriptionController.text,
  //     'category': _categoryController.text,
  //     'id': user?.uid,
  //     'imageurl': imageUrl
  //   });
  //   Navigator.pop(context);
  // }

  Future<void> _updateTask() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(selectedDate);

    await _db.collection('tasks').doc(widget.task.taskId).update({
      'title': _titleController.text, 
      'description': _descriptionController.text,
      'category': _categoryController.text,
      'date' : outputDate
    });

    Navigator.of(context).pop();
  }
}
