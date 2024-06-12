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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Title'),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 239, 234, 234),
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    labelText: widget.task.title,
                  ),
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
                  controller:
                      _dateController, // Use _dateController for displaying selected date
                  decoration: InputDecoration(
                    hintText: 'Select date',
                    filled: true,
                    fillColor: Color.fromARGB(255, 239, 234, 234),
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    labelText: widget.task.date,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Description'),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 239, 234, 234),
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    labelText: widget.task.description,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add category'),
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 239, 234, 234),
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    labelText: widget.task.category,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
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
}
